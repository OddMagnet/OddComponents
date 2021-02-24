//
//  OddNetworking.swift
//  OddComponents
//
//  Created by Michael Brünen on 09.12.20.
//

import Foundation
import Combine

enum UploadError: Error {
    case uploadFailed
    case decodeFailed
}

func fetch<T: Decodable>(
    _ url: URL,
    withRetries retries: Int = 1,
    withDecoder decoder: JSONDecoder = JSONDecoder(),
    defaultValue: T,
    receiveOn thread: DispatchQueue = .main,
    storeIn store: inout Set<AnyCancellable>,
    completion: @escaping (T) -> Void
) {
    URLSession.shared.dataTaskPublisher(for: url)
        .retry(retries)                         // retry `x` times if the request fails
        .map(\.data)                            // publisher sends data, response and error, this filters out the data
        .decode(type: T.self, decoder: decoder) // then decode the data
        .replaceError(with: defaultValue)       // make sure there is data, even if an error occurred
        .receive(on: thread)                    // select on which thread to run the pipeline
        .sink(receiveValue: completion)         // do some custom actions
        .store(in: &store)                      // finally, store it
}

func fetch<T: Decodable>(
    _ url: URL,
    withRetries retries: Int = 1,
    withDecoder decoder: JSONDecoder = JSONDecoder(),
    defaultValue: T,
    receiveOn thread: DispatchQueue = .main
) -> AnyPublisher<T, Never> {
    URLSession.shared.dataTaskPublisher(for: url)
        .retry(retries)                         // retry `x` times if the request fails
        .map(\.data)                            // publisher sends data, response and error, this filters out the data
        .decode(type: T.self, decoder: decoder) // then decode the data
        .replaceError(with: defaultValue)       // make sure there is data, even if an error occurred
        .receive(on: thread)                    // select on which thread to run the pipeline
        .eraseToAnyPublisher()                  // type erasure to avoid extremely long types
}

func upload<Input: Encodable, Output: Decodable>(
    _ data: Input,
    to url: URL,
    withEncoder encoder: JSONEncoder = JSONEncoder(),
    httpMethod: String = "POST",
    contentType: String = "application/json",
    receiveOn thread: DispatchQueue = .main,
    storeIn store: inout Set<AnyCancellable>,
    completion: @escaping (Result<Output, UploadError>) -> Void
) {
    // ready the request
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    request.httpBody = try? encoder.encode(data)

    // start the upload
    URLSession.shared.dataTaskPublisher(for: request)
        .map(\.data)
        .decode(type: Output.self, decoder: JSONDecoder())
        .map(Result.success)
        .catch { error -> Just<Result<Output, UploadError>> in  // wrap the resul in the `Just` publisher since Combine operators need to return publishers,
                                                                // so all further operators can continue to work with those
            error is DecodingError
                ? Just(.failure(.decodeFailed))
                : Just(.failure(.uploadFailed))
        }
        .receive(on: thread)
        .sink(receiveValue: completion)
        .store(in: &store)
}
