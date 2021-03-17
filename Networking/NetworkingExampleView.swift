//
//  NetworkingExampleView.swift
//  OddComponents
//
//  Created by Michael Brünen on 09.12.20.
//

import SwiftUI
import Combine  // for AnyCancellable

struct User: Codable {
    var id: UUID
    var name: String

    static let `default` = User(id: UUID(), name: "OddMagnet")
}

struct Message: Decodable, Identifiable {
    var id: Int
    var from: String
    var message: String
}

struct NewsItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
    let main_image: String
    let published_date: Date
}

struct NetworkingExampleView: View {
    @State private var requests = Set<AnyCancellable>()
    @State private var messages = [Message]()
    @State private var favorites = Set<Int>()
    @State private var items = [NewsItem]()

    var body: some View {
        NavigationView {
            VStack {
                Button("Fetch news") {
                    // fetch the news!
                    let url = URL(string: "https://www.hackingwithswift.com/samples/news.json")!
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    // create a publisher that contains an array of urls
                    fetch(url, withDecoder: decoder, defaultValue: [URL]())
                        // map the array of urls into an array of Publishers containing NewsItems (flatMap so it doesn't become array of Publishers of Publishers)
                        .flatMap { urls in
                            // use the arrays Sequence Publisher - a Publisher that publishes every element individually in sequence
                            // call flatMap on the Publisher to get the individual URLs and return a new publisher in it's place
                            urls.publisher.flatMap { url in
                                // fetch every url in the array, returns a Publisher containing a NewsItem
                                fetch(url, defaultValue: [NewsItem]())
                            }
                        }
                        // wait for all elements to finish, then send them further down as an array of arrays
                        .collect()
                        // then join the arrays and assign it to the items variable
                        .sink { values in
                            let allItems = values.joined()
                            items = allItems.sorted { $0.id > $1.id }
                        }
                        // finally, store the publisher
                        .store(in: &requests)
                }

                List(items) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.strap)
                            .foregroundColor(.secondary)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Hacking with Swift")
        }

        /** Old Demo Stuff 2
        NavigationView {
            List(messages) { message in
                HStack {
                    VStack(alignment: .leading) {
                        Text(message.from)
                            .font(.headline)
                        Text(message.message)
                            .foregroundColor(.secondary)
                    }

                    if favorites.contains(message.id) {
                        Spacer()

                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Messages")
        }
        .onAppear {
            let messagesURL = URL(string: "https://www.hackingwithswift.com/samples/user-messages.json")!
            let favoritesURL = URL(string: "https://www.hackingwithswift.com/samples/user-favorites.json")!

            /* V1 of fetching data

            fetch(messagesURL, defaultValue: [Message](), storeIn: &requests)
            {
                messages = $0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                fetch(favoritesURL, defaultValue: Set<Int>(), storeIn: &requests) {
                    favorites = $0
                }
            }
            */

            /* V2 of fetching data */
            // create two publishers, one for each task
            let messagesTask = fetch(messagesURL, defaultValue: [Message]())
            let favoritesTask = fetch(favoritesURL, defaultValue: Set<Int>())
            // zip them, so we can continue when both are finished
            let combinedTask = Publishers.Zip(messagesTask, favoritesTask)
            // sink them, to work with the returned values and store the
            combinedTask.sink { loadedMessages, loadedFavorites in
                messages = loadedMessages
                favorites = loadedFavorites
            }
            .store(in: &requests)
        }
        */

        /** Old Demo Stuff
         VStack {
         Spacer()

         Button("Fetch Data") {
         let url = URL(string: "https://www.hackingwithswift.com/samples/user-24601.json")!
         fetch(
         url,
         withRetries: 3,
         defaultValue: User.default,
         receiveOn: DispatchQueue.main,
         storeIn: &requests
         ) { user in
         print(user.name)
         }
         }

         Spacer()

         Button("Send Data") {
         let user = User.default
         let url = URL(string: "https://reqres.in/api/users")!

         upload(user, to: url, storeIn: &requests) { (result: Result<User, UploadError>) in
         switch result {
         case .success(let user):
         print("Received user: \(user.name)")
         case .failure(let error):
         print(error)
         break
         }
         }
         }

         Spacer()
         }
         */
    }
}

struct NetworkingExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkingExampleView()
    }
}
