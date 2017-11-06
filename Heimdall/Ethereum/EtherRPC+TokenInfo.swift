//
//  EtherRPC+TokenInfo.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit

extension EtherRPC {
    func tokenInfo(for address: String) -> Signal<Token, Error> {
        let nameSignal = call(HumanStandardToken.Name.self, ofContractAt: address, with: ())
            .map { $0.value }
        let symbolSignal = call(HumanStandardToken.Symbol.self, ofContractAt: address, with: ())
            .map { $0.value }
        // We can use forcedInt here, as the return value is only Solidity.UInt8
        let decimalsSignal = call(HumanStandardToken.Decimals.self, ofContractAt: address, with: ())
            .map { $0.value.forcedInt }

        return combineLatest(nameSignal, symbolSignal, decimalsSignal)
            .map { Token(address: address, name: $0.0, symbol: $0.1, decimals: $0.2) }
    }
}
