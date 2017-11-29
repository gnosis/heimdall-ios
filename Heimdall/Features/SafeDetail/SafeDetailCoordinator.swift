//
//  SafeDetailCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 27.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

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
                _ = mySelf.coordinate(to: ShareCoordinator(shareable: mySelf.safe,
                                                           rootViewController: viewController))
            }
            .dispose(in: bag)

        return Signal.never()
    }
}
