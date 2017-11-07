//
//  TokenListViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

class TokenListViewModel {
    private let store: AppDataStore<Token>
    private let disposeBag = DisposeBag()

    let items = Property<[TokenListCellViewModel]>([])
    let title = Property("Token List")

    var addToken: SafeSignal<Void>?
    var deleteToken: SafeSignal<IndexPath>? {
        didSet {
            deleteToken?
                .with(latestFrom: store.contents)
                .observeNext { indexPath, tokens in
                    let token = tokens[indexPath.row]
                    _ = try? self.store.remove(token)
            }
            .dispose(in: disposeBag)
        }
    }

    init(credentials: Credentials, rpc: EtherRPC, store: AppDataStore<Token>) {
        self.store = store
        store.contents.flatMap {
            TokenListCellViewModel(credentials: credentials, rpc: rpc, token: $0)
        }.bind(to: items)
    }
}
