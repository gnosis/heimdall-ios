//
//  SecureDataStore.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 25.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation
import KeychainAccess

class SecureDataStore {
    private let keychain = Keychain()
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

// MARK: - DataStore
extension SecureDataStore: DataStore {
    func store<T>(_ data: T, for key: String) throws where T: Codable {
        let json = try encoder.encode(data)
        try keychain.set(json, key: key)
    }

    func fetch<T>(key: String) throws -> T where T: Codable {
        guard let json = try keychain.getData(key) else {
            throw DataStoreError.noSuchEntry
        }
        let object = try decoder.decode(T.self, from: json)
        return object
    }

    func delete(key: String) throws {
        try keychain.remove(key)
    }
}
