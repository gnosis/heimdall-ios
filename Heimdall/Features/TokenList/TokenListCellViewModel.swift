//
//  TokenListCellViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit

class TokenListCellViewModel {
    let textLabelText = Property("")
    let detailTextLabelText = Property("")

    init(credentials: Credentials, rpc: EtherRPC, token: Token) {
        detailTextLabelText.value = "\(token.address)"
        rpc.balance(of: credentials.address, for: token)
            .map { $0.description }
            .flatMapError { _ in Signal.just("N/A") }
            .map { "Balance: \($0)" }
            .map { "\(token.name) (\(token.symbol)) (\($0))" }
            .bind(to: textLabelText)
    }
}
