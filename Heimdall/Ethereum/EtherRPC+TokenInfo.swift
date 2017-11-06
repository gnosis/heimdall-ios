//
//  EtherRPC+TokenInfo.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt
import Bond
import ReactiveKit

extension EtherRPC {
    func tokenInfo(for address: String) -> Signal<Token, Error> {
        let nameSignal = call(HumanStandardToken.Name.self, ofContractAt: address)
            .map { $0.value }
        let symbolSignal = call(HumanStandardToken.Symbol.self, ofContractAt: address)
            .map { $0.value }
        // We can use forcedInt here, as the return value is only Solidity.UInt8
        let decimalsSignal = call(HumanStandardToken.Decimals.self, ofContractAt: address)
            .map { $0.value.forcedInt }

        return combineLatest(nameSignal, symbolSignal, decimalsSignal)
            .map {
                Token(address: address,
                      name: $0.0,
                      symbol: $0.1,
                      decimals: $0.2,
                      whitelisted: false)
        }
    }

    func balance(of address: String, for token: Token) -> Signal<BigUInt, Error> {
        guard let solidityAddress = try? Solidity.Address(address) else {
            return Signal.failed(.invalidArguments)
        }
        return call(StandardToken.BalanceOf.self,
                    ofContractAt: token.address,
                    with: solidityAddress)
            .map { $0.value }
    }
}
