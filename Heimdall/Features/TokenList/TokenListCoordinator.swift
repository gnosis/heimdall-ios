//
//  TokenListCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class TokenListCoordinator: TabCoordinator {
    let rpc: EtherRPC
    let credentials: Credentials
    let tokenProvider: VerifiedTokenProvider
    let store: DataStore

    init(credentials: Credentials,
         rpc: EtherRPC,
         whiteListTokenProvider: VerifiedTokenProvider,
         store: DataStore) {
        self.rpc = rpc
        self.credentials = credentials
        self.tokenProvider = whiteListTokenProvider
        self.store = store
        super.init()
    }

    override var tabBarItem: UITabBarItem {
        return UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
    }

    override func start() -> Signal<Void, NoError> {
        let tokenStore = AppDataStore<Token>(store: store)
        // Make sure we have our whitelist in the store
        _ = try? tokenStore.add(tokenProvider.verifiedTokens)

        let balanceRepo = BalanceRepo(rpc: rpc)
        let tokenListViewModel = TokenListViewModel(credentials: credentials, repo: balanceRepo, store: tokenStore)
        let tokenListViewController = TokenListViewController(viewModel: tokenListViewModel)
        navigationController.rootViewController = tokenListViewController

        tokenListViewModel.addToken
            .flatMapLatest { _ in
                self.coordinate(to: AddTokenCoordinator(navigationController: self.navigationController, rpc: self.rpc))
            }.flatMap { (result: AddTokenCoordinator.CoordinationResult) -> Token? in
                guard case .token(let newToken) = result else {
                    return nil
                }
                return newToken
            }.observeNext { token in
                _ = try? tokenStore.add(token)
            }.dispose(in: disposeBag)

        return Signal.never()
    }
}
