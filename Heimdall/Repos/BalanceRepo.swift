//
//  BalanceRepo.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 09.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class BalanceRepo {
    let rpc: EtherRPC

    init(rpc: EtherRPC) {
        self.rpc = rpc
    }

    func balance(of address: String, for token: Token) -> Signal<Balance, EtherRPC.Error> {
        return rpc
            .balance(of: address, for: token)
            .map { Balance(token: token, ownerAddress: address, amount: $0) }
    }

    func balances(of address: String, for tokens: [Token]) -> Signal<[Balance], NoError> {
        return combineLatest(tokens.map {
            balance(of: address, for: $0).suppressError(logging: true)
        }) { $0 }
    }
}
