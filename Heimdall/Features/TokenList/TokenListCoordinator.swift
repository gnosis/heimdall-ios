//
//  TokenListCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ethers
import ReactiveKit
import UIKit

class TokenListCoordinator: TabCoordinator {
    let rpc: EtherRPC

    init(rpc: EtherRPC) {
        self.rpc = rpc
        super.init()
    }

    override var tabBarItem: UITabBarItem {
        return UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
    }

    override func start() -> Signal<Void, NoError> {
        let dataStore = ApplicationSupportDataStore()
        let tokenStore = AppDataStore<Token>(store: dataStore)
        let tokenListViewModel = TokenListViewModel(store: tokenStore)
        let tokenListViewController = TokenListViewController(viewModel: tokenListViewModel)
        navigationController.rootViewController = tokenListViewController

        tokenListViewModel.addToken?.flatMapLatest { _ in
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
