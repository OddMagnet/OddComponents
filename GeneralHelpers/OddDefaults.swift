//
//  OddDefaults.swift
//  OddComponents
//
//  Created by Michael Brünen on 21.12.20.
//

import Foundation

/**
 - UserDefaults & iCloud Storage in one
 - To use this App-wide, place `OddDefaults.shared.start()` e.g. in the AppDelegates `didFinishLaunchingWithOptions`
 - Default prefix for keys is `odd-`, this can be changed via the `setPrefix` method
 */
final class OddDefaults {
    static let shared = OddDefaults()
    private var syncingLocal = false
    private(set) var prefix = "odd-"

    /// TEST
    private init() { }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// Sets a new prefix for the syncing of defaults
    /// - Parameter newPrefix: The new prefix
    func setPrefix(to newPrefix: String) { prefix = newPrefix }

    /// Starts the automatic sync between local and remote
    func start() {
        // Observer for remote changes
        NotificationCenter.default.addObserver(
            forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default,
            queue: .main,
            using: updateLocal
        )

        // Observer for local changes
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main,
            using: updateRemote
        )

        // Start sync
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    private func updateLocal(notification: Notification) {
        // ensure the local sync doesn't trigger remote sync
        syncingLocal = true

        for (key, value) in NSUbiquitousKeyValueStore.default.dictionaryRepresentation {
            guard key.hasPrefix(prefix) else { continue }   // only sync values with prefix
            UserDefaults.standard.set(value, forKey: key)
            print("Updated local value of \(key) to \(value)")
        }

        // reset flag
        syncingLocal = false
    }

    private func updateRemote(notification: Notification) {
        guard syncingLocal == false else { return }

        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            guard key.hasPrefix(prefix) else { continue }   // only sync values with prefix
            NSUbiquitousKeyValueStore.default.set(value, forKey: key)
            print("Updated remote value of \(key) to \(value)")
        }
    }

}


struct Test {
    let defaults = OddDefaults.shared
}
