//
//  TokenListViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit

class TokenListViewModel {
    private let store: AppDataStore<Token>

    let items = Property<[TokenListCellViewModel]>([])

    var addToken: SafeSignal<Void>?

    init(store: AppDataStore<Token>) {
        self.store = store
        store.contents.flatMap { TokenListCellViewModel(token: $0) }.bind(to: items)
    }
}
