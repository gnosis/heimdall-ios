//
//  MnemonicPhrase.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 26.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ethers

struct MnemonicPhrase {
    enum Error: String, Swift.Error {
        case accountWithNilMnemonicPhrase = "Account returned nil mnemonic phrase."
    }

    static var random: String {
        guard let phrase = Account.randomMnemonic()?.mnemonicPhrase else {
            die(Error.accountWithNilMnemonicPhrase)
        }
        return phrase
    }

    static func isValid(_ phrase: String) -> Bool {
        return Account.isValidMnemonicPhrase(phrase)
    }
}
