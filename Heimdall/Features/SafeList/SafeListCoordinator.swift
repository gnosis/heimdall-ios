//
//  SafeListCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

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
            .addSafe
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
            .dispose(in: disposeBag)
        return Signal.never()
    }
}
