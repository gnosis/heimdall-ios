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
    private let disposeBag = DisposeBag()

    private let displayedBalances = Property<[Balance]>([])
    let items = Property<[TokenListCellViewModel]>([])
    let title = Property("TokenList.ViewController.Title".localized)

    var addToken = SafePublishSubject<Void>()
    var deleteToken = SafePublishSubject<IndexPath>()
    var refreshing = SafePublishSubject<Bool>()

    init(credentials: Credentials, repo: BalanceRepo, store: AppDataStore<Token>) {
        // General fetching/refreshing logic
        // We only want to trigger a new refresh if the store contents changed
        // or refreshing is newly `true`. Also immediately trigger a loading call.
        // swiftlint:disable:next trailing_closure
        combineLatest(refreshing.filter { $0 }.start(with: true), store.contents)
            .flatMapLatest { _, tokens -> Signal<[Balance], NoError> in
                repo.balances(of: credentials.address, for: tokens)
            }
            .map { balances -> [Balance] in
                // Filter out unwanted tokens (not custom && zero amount)
                balances.filter { !$0.token.whitelisted || $0.amount > 0 }
            }.doOn(next: { _ in
                // Finish refreshing (for UI & reset purposes)
                // TODO: This does not end refreshing on errors of the signal
                self.refreshing.next(false)
            })
            .bind(to: displayedBalances)
            .dispose(in: disposeBag)
        // Map Balances to cell view models
        displayedBalances
            .flatMap { TokenListCellViewModel(balance: $0) }
            .bind(to: items)
            .dispose(in: disposeBag)
        // Handle cell deletions
        deleteToken
            .with(latestFrom: displayedBalances)
            .observeNext { indexPath, balances in
                let token = balances[indexPath.row].token
                _ = try? store.remove(token)
            }
            .dispose(in: disposeBag)
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
