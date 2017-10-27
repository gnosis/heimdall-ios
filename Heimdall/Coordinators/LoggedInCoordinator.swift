//
//  LoggedInCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
import ReactiveKit

class LoggedInCoordinator: BaseCoordinator<Void> {
    let window: UIWindow
    let credentials: Credentials

    init(with window: UIWindow, credentials: Credentials) {
        self.window = window
        self.credentials = credentials
    }

    override func start() -> Signal<Void, NoError> {
        let accountViewController = AccountViewController(with: credentials)
        let navigationController = UINavigationController(rootViewController: accountViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Signal.never()
    }
}
