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
