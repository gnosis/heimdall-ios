//
//  SafeDetailViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 21.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class SafeDetailViewModel: SeparatedViewModel {
    // MARK: SeparatedViewModel
    typealias View = SafeDetailView
    let title = Property<String?>("")

    // MARK: Custom Stuff
    let shareSafeAction = SafePublishSubject<Void>()

    init(safe: Safe) {
        title.value = safe.name ?? safe.address
    }
}
