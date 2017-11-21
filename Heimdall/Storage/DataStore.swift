//
//  DataStore.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 25.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

protocol DataStore {
    /// Stores the given object in the store. Can be retrieved later with the
    /// same key.
    ///
    /// - Parameters:
    ///   - data: The object to store.
    ///   - key: The key to use for storing & retrieving.
    /// - Throws: When storing fails.
    func store<T>(_ data: T, for key: String) throws where T: Codable

    /// Tries to fetch the object associated with that key.
    ///
    /// - Parameter key: The key to use for storing & retrieving.
    /// - Returns: The object associated with that key.
    /// - Throws: When fetching fails or no object is associated with that key.
    func fetch<T>(key: String) throws -> T where T: Codable

    /// Deletes the object associated with the key.
    ///
    /// - Parameter key: Key identifying the object.
    /// - Throws: When deleting fails or no object is associated with that key.
    func delete(key: String) throws
}

/// Describes errors that can occur when storing & fetching objects.
///
/// - noSuchEntry: Key is not associated with any object.
/// - invalidKey: Key contains illegal characters.
internal enum DataStoreError: Error {
    case noSuchEntry
    case invalidKey
}
