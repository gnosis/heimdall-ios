//
//  SafeListCellViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit

class SafeListCellViewModel {
    let textLabelText = Property("")
    let detailTextLabelText = Property("")
    let safe: Safe

    init(safe: Safe) {
        self.safe = safe
        textLabelText.value = "\(safe.name ?? safe.address)"
        detailTextLabelText.value = "\(safe.address)"
    }
}
