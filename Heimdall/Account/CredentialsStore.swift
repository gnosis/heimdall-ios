//
//  CredentialsStore.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 07.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

class CredentialsStore {
    private let storeKey = "pm.gnosis.Heimdall.Credentials"
    private let store: DataStore

    /// Creates a new credentials store by using the given store as a storage backend.
    ///
    /// - Parameter store: Underlying storage to use for the credentials.
    ///     This should be a secure store, e.g. Keychain or `SecureDataStore`.
    init(store: DataStore) {
        self.store = store
    }

    func fetchCredentials() throws -> Credentials {
        return try store.fetch(key: storeKey)
    }

    var hasStoredCredentials: Bool {
        return (try? fetchCredentials()) != nil
    }

    func store(credentials: Credentials) throws {
        try store.store(credentials, for: storeKey)
    }
}
