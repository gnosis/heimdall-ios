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

    init(balance: Balance) {
        let token = balance.token
        detailTextLabelText.value = "\(token.address)"
        textLabelText.value = "\(token.name) (\(balance.amount) \(token.symbol))"
    }
}
