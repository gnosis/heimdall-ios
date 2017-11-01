//
//  Secrets.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 01.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

enum SecretsKey: String {
    case infuraKey
}

private extension Bundle {
    func secret(for key: SecretsKey) -> String {
        guard let secret = object(forInfoDictionaryKey: key.rawValue) as? String else {
            die("Secret with key \(key.rawValue) could not be found in Info.plist")
        }
        return secret
    }
}

struct Secrets {
    subscript(key: SecretsKey) -> String {
        return Bundle.main.secret(for: key)
    }
}
