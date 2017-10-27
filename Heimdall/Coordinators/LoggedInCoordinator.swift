//
//  LoggedInCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class LoggedInCoordinator: BaseCoordinator<Void> {
    let window: UIWindow
    let credentials: Credentials

    init(with window: UIWindow, credentials: Credentials) {
        self.window = window
        self.credentials = credentials
    }

    override func start() -> Signal<Void, NoError> {
        let accountViewModel = AccountOverviewViewModel(credentials: credentials)
        let accountViewController = AccountViewController(viewModel: accountViewModel)
        let navigationController = UINavigationController(rootViewController: accountViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Signal.never()
    }
}
