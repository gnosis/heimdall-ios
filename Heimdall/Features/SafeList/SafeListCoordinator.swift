//
//  SafeListCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class PushableCoordinator: BaseCoordinator<Void> {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

class SafeDetailCoordinator: PushableCoordinator {
    let safe: Safe

    init(navigationController: UINavigationController,
         safe: Safe) {
        self.safe = safe
        super.init(navigationController: navigationController)
    }

    override func start() -> Signal<Void, NoError> {
        let viewModel = SafeDetailViewModel(safe: safe)
        let viewController = SafeDetailViewController(viewModel: viewModel)
        push(viewController)

        viewModel
            .shareSafeAction
            .bind(to: self) { mySelf, _ in
                mySelf.coordinate(to: ShareQRCodeCoordinator(title: mySelf.safe.name ?? mySelf.safe.address,
                                                             payload: mySelf.safe.address,
                                                             rootViewController: viewController))
            }
            .dispose(in: bag)
        return Signal.never()
    }
}

class SafeListCoordinator: TabCoordinator {
    let store: DataStore

    init(store: DataStore) {
        self.store = store
        super.init()
    }

    override var tabBarItem: UITabBarItem {
        return UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    }

    override func start() -> Signal<Void, NoError> {
        let safeStore = AppDataStore<Safe>(store: store)
        let safeListViewModel = SafeListViewModel(store: safeStore)
        let safeListViewController = SafeListViewController(viewModel: safeListViewModel)
        navigationController.rootViewController = safeListViewController

        safeListViewModel
            .addSafeAction
            .flatMapLatest { _ in
                self.coordinate(to: AddSafeCoordinator(navigationController: self.navigationController))
            }
            .flatMap { (result: AddSafeCoordinator.CoordinationResult) -> Safe? in
                guard case .safe(let newSafe) = result else {
                    return nil
                }
                return newSafe
            }
            .observeNext { safe in
                _ = try? safeStore.add(safe)
            }
            .dispose(in: bag)

        safeListViewModel
            .openSafeAction
            .observeNext { safe in
                _ = self.coordinate(to:
                    SafeDetailCoordinator(navigationController: self.navigationController,
                                          safe: safe))
            }
            .dispose(in: bag)
        return Signal.never()
    }
}
