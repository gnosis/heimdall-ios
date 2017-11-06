//
//  Token.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

struct Token: Storable {
    let name: String
    let symbol: String
    let decimals: Int

    init(name: String, symbol: String, decimals: Int) {
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
    }

    static var storageKey: String {
        return "Token"
    }
}

// MARK: - Equatable
extension Token: Equatable {
    static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}
