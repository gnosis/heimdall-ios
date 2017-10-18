//
//  AccountManager.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 07.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation
import ethers
import KeychainAccess

extension Keychain {
    subscript(key: Key) -> String? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
}

enum Key: String {
    case mainAccountPrivateKey
}

extension Account {
    var privateKey: String {
        guard let key = self.value(forKey: "_privateKey") as? SecureData else {
            die("NO PRIVATE KEY OR NO SECURE DATA")
        }
        return key.hexString()
    }
    
    convenience init(privateKeyHex: String) {
        self.init(privateKey: SecureData(hexString: privateKeyHex).data())
    }
}

struct AccountManager {
    // FIXME: use DI for this, maybe wrap whole keychain in a small interface with
    // Key enum
    private static let keychain = Keychain()
    
    fileprivate static func randomNewAccount() -> Account {
        print("Creating a new account with random phrase")
        return Account.randomMnemonic()
    }
    
    static func account(from mnemonicPhrase: String? = nil) -> Account {
        guard let phrase = mnemonicPhrase else {
            return randomNewAccount()
        }
        print("Creating an account with phrase \(phrase)")
        return Account(mnemonicPhrase: phrase)
    }
    
    static var hasStoredAccount: Bool {
        return storedAccount != nil
    }
    
    static var storedAccount: Account? {
        guard let privateKeyHex = keychain[.mainAccountPrivateKey] else {
            print("Found no stored account")
            
            return nil
        }
        print("Found a stored account with private key \(privateKeyHex)")
        return Account(privateKeyHex: privateKeyHex)
    }
    
    static func store(account: Account) {
        // TODO: think about storing in the icloud keychain
        let privateKey = account.privateKey
        keychain[.mainAccountPrivateKey] = privateKey
        print("Stored account with private key \(privateKey)")
    }
}
