//
//  Token.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

struct Token: Storable {
    let address: String
    let name: String
    let symbol: String
    let decimals: Int
    let whitelisted: Bool

    init(address: String, name: String, symbol: String, decimals: Int, whitelisted: Bool) {
        self.address = address
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
        self.whitelisted = whitelisted
    }

    static var storageKey: String {
        return "Token"
    }
}

// MARK: - Equatable
extension Token: Equatable {
    static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.address == rhs.address
    }
}
