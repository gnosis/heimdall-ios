//
//  Credentials.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 26.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ethers

struct Credentials: Codable {
    enum CredentialsError: Error {
        case invalidMnemonicPhrase
    }
    
    /// Address of this account
    let address: String
    /// Private Key as a Hex String
    let privateKey: String
    
    private init(account: Account) {
        privateKey = account.privateKey
        guard let addressString = account.address?.description else {
            die("Credentials initialized with an Account without address")
        }
        address = addressString
    }
    
    init(from mnemonicPhrase: String) throws {
        guard MnemonicPhrase.isValid(mnemonicPhrase),
            let account = Account(mnemonicPhrase: mnemonicPhrase) else {
                throw CredentialsError.invalidMnemonicPhrase
        }
        self.init(account: account)
    }
}

// MARK: - Account Extension
private extension Account {
    var privateKey: String {
        guard let key = self.value(forKey: "_privateKey") as? SecureData else {
            die("NO PRIVATE KEY OR NO SECURE DATA")
        }
        return key.hexString()
    }
}
