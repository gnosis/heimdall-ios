//
//  Balance.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 09.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt

struct Balance: Storable {
    let token: Token
    let ownerAddress: String
    let amount: BigUInt

    static var storageKey: String {
        return "Balance"
    }
}

extension Balance: Equatable {
    static func == (lhs: Balance, rhs: Balance) -> Bool {
        return lhs.ownerAddress == rhs.ownerAddress
            && lhs.token == rhs.token
    }
}
