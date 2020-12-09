//
//  OddNetworking.swift
//  OddComponents
//
//  Created by Michael Brünen on 09.12.20.
//

import Foundation
import Combine

func fetch<T: Decodable>(
    _ url: URL,
    withRetries retries: Int = 1,
    withDecoder decoder: JSONDecoder = JSONDecoder(),
    defaultValue: T,
    receiveOn thread: DispatchQueue = .main,
    completion: @escaping (T) -> Void,
    storeIn store: inout Set<AnyCancellable>
) {
    URLSession.shared.dataTaskPublisher(for: url)
        .retry(retries)                         // retry `x` times if the request fails
        .map(\.data)                            // publisher sends data, response and error, this filters out the data
        .decode(type: T.self, decoder: decoder) // then decode the data
        .replaceError(with: defaultValue)       // make sure there is data, even if an error occured
        .receive(on: thread)                    // select on which thread to run the pipeline
        .sink(receiveValue: completion)         // do some custom actions
        .store(in: &store)                      // finally, store it
}
