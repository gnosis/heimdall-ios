//
//  Credentials.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 26.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ethers

struct Credentials: Codable {
    enum Error: Swift.Error {
        case invalidMnemonicPhrase
    }

    /// Address of this account with leading 0x
    let address: String
    /// Private key in binary form
    let privateKeyData: Data
    /// Private Key as a Hex String with leading 0x
    var privateKey: String {
        return "0x\(privateKeyData.hexEncodedString())"
    }

    private init(account: Account) {
        guard let privateKeyData = Data(fromHexEncodedString: String(account.privateKey.dropFirst(2))) else {
            die("Credentials initialized with an Account with invalid private key")
        }
        self.privateKeyData = privateKeyData
        guard let addressString = account.address?.description else {
            die("Credentials initialized with an Account without address")
        }
        address = addressString
    }

    init(from mnemonicPhrase: String) throws {
        guard MnemonicPhrase.isValid(mnemonicPhrase),
            let account = Account(mnemonicPhrase: mnemonicPhrase) else {
                throw Error.invalidMnemonicPhrase
        }
        self.init(account: account)
    }
}

// MARK: - Account Extension
private extension Account {
    var privateKey: String {
        guard let key = self.value(forKey: "_privateKey") as? SecureData else {
            die("Account.privateKey could not retrieve _privateKey")
        }
        return key.hexString()
    }
}
