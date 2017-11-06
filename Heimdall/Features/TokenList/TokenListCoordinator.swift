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

class TokenListCoordinator: BaseCoordinator<Void> {
    let window: UIWindow

    init(with window: UIWindow) {
        self.window = window
    }

    override func start() -> Signal<Void, NoError> {
        let dataStore = ApplicationSupportDataStore()
        let tokenStore = AppDataStore<Token>(store: dataStore)
        let tokenListViewModel = TokenListViewModel(store: tokenStore)
        let tokenListViewController = TokenListViewController(viewModel: tokenListViewModel)
        let navigationController = UINavigationController(rootViewController: tokenListViewController)

        tokenListViewModel.addToken?.flatMapLatest {
            return self.coordinate(to: AddTokenCoordinator(navigationController: navigationController))
        }.flatMap { (result: AddTokenCoordinator.CoordinationResult) -> Token? in
            guard case .token(let newToken) = result else {
                return nil
            }
            return newToken
        }.observeNext { token in
            _ = try? tokenStore.add(token)
        }.dispose(in: disposeBag)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Signal.never()
    }
}
