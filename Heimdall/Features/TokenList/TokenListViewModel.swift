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

    private let displayedBalances = Property<[Balance]>([])
    private let fetchingBalances = Property(true)
    let items = Property<[TokenListCellViewModel]>([])
    let title = Property("Token List")

    var addToken: SafeSignal<Void>?
    var deleteToken: SafeSignal<IndexPath>? {
        didSet {
            deleteToken?
                .with(latestFrom: displayedBalances)
                .observeNext { indexPath, balances in
                    let token = balances[indexPath.row].token
                    _ = try? self.store.remove(token)
            }
            .dispose(in: disposeBag)
        }
    }

    init(credentials: Credentials, repo: BalanceRepo, store: AppDataStore<Token>) {
        self.store = store
        store.contents
            .flatMapLatest { tokens -> Signal<[Balance], NoError> in
                repo.balances(of: credentials.address, for: tokens)
                    .map { (balances: [Balance]) -> [Balance] in
                        balances.filter { !$0.token.whitelisted || $0.amount > 0 }
                }
            }
            .feedFetching(into: fetchingBalances)
            .bind(to: displayedBalances)
        displayedBalances
            .flatMap { TokenListCellViewModel(balance: $0) }
            .bind(to: items)
    }
}

public extension SignalProtocol {
    /// Update the given subject with `true` when the receiver starts and with
    /// `false` when the receiver receives the first element.
    func feedFetching<S: SubjectProtocol>(into listener: S)
        -> Signal<Element, Error> where S.Element == Bool {
            return doOn(next: { _ in
                listener.next(false)
            }, start: {
                listener.next(true)
            })
    }
}
