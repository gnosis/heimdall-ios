//
//  DiskDataStore.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 25.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation
import Disk

/// Base class for disk data stores. Not meant to be used directly, only for
/// subclassing.
class DiskDataStore {
    var directory: Disk.Directory {
        die("DiskDataStore.directory needs to be overridden")
    }

    private func fileName(from key: String) throws -> String {
        guard let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw DataStoreError.invalidKey
        }
        return "\(escapedKey).json"
    }
}

// MARK: - DataStore
extension DiskDataStore: DataStore {
    func store<T>(_ data: T, for key: String) throws where T: Codable {
        let filename = try fileName(from: key)
        try Disk.save(data, to: directory, as: filename)
    }

    func fetch<T>(key: String) throws -> T where T: Codable {
        let filename = try fileName(from: key)
        return try Disk.retrieve(filename, from: directory, as: T.self)
    }
    
    func delete(key: String) throws {
        let filename = try fileName(from: key)
        try Disk.remove(filename, from: directory)
    }
}

/// Stores data in the ApplicationSupport directory.
/// Should be used for data that is important but should not be visible to the user.
/// Use `DocumentsDataStore` for user generated data.
final class ApplicationSupportDataStore: DiskDataStore {
    override var directory: Disk.Directory {
        return .applicationSupport
    }
}

/// Stores data in the Documents directory.
/// Should be used for data that is important and should be visible to the user.
final class DocumentsDataStore: DiskDataStore {
    override var directory: Disk.Directory {
        return .documents
    }
}
