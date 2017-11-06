//
//  TokenListCellViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class TokenListCellViewModel {
    let textLabelText = Property("")
    let detailTextLabelText = Property("")

    init(token: Token) {
        textLabelText.value = "\(token.name) (\(token.symbol))"
        detailTextLabelText.value = "Decimals: \(token.decimals)"
    }
}
