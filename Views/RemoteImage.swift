//
//  RemoteImage.swift
//  OddComponents
//
//  Created by Michael Brünen on 17.02.21.
//

import SwiftUI

struct RemoteImage: View {
    // Represents the current state of loading the image
    private enum LoadState {
        case loading, success, failure
    }

    // Handles the actual loading and notifying of other views that some change has happened
    // No published properties, updates are triggered by `objectWillChange.send()` in the initialiser
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        // Initialiser with a string to stay consistent with how Images are usually initialised
        init(url: String) {
            guard let parsedURL = URL(string: url) else { fatalError("Invalid URL: \(url)") }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                DispatchQueue.main.async {
                    if let data = data, data.count > 0 {
                        self.data = data
                        self.state = .success
                    } else {
                        self.state = .failure
                    }

                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    // Properties
    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image

    init(
        url: String,
        loading: Image = Image(systemName: "photo"),
        failure: Image = Image(systemName: "multiply.circle")
    ) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }

    var body: some View {
        loadedImage()
            .resizable()
    }

    private func loadedImage() -> Image {
        switch loader.state {
            case .loading:
                return loading
            case .failure:
                return failure
            default:
                if let image = UIImage(data: loader.data) {
                    return Image(uiImage: image)
                } else {
                    return failure
                }
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "https://avatars.githubusercontent.com/u/34708235")
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: 200)
    }
}
