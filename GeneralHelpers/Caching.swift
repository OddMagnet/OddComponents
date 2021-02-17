//
//  Caching.swift
//  OddComponents
//
//  Created by Michael Brünen on 17.02.21.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    private var wrapped = NSCache<WrappedKey, Entry>()

    /// Inserts a value for a specific key into the cache
    /// - Parameters:
    ///   - value: The value to insert
    ///   - key: The key the value is inserted under
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    /// Returns a value for a given key
    /// - Parameter key: The key of the value to be returned
    /// - Returns: The value for the given key if it exists, otherwise nil
    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    /// Removes a value from the cache
    /// - Parameter key: The key of the value to remove
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension Cache {
    /// Wraps the public-facing key values  to make them compatible with NSCache
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }

    /// Stores the cached value
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}
