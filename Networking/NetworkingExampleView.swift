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

struct NetworkingExampleView: View {
    @State private var requests = Set<AnyCancellable>()

    var body: some View {
        Button("Fetch Data") {
            let url = URL(string: "https://www.hackingwithswift.com/samples/user-24601.json")!
            fetch(
                url,
                withRetries: 3,
                defaultValue: User.default,
                receiveOn: DispatchQueue.main,
                completion: { print($0.name) },
                storeIn: &requests
            )
        }
    }
}

struct NetworkingExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkingExampleView()
    }
}
