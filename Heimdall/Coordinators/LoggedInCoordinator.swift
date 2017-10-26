//
//  LoggedInCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class LoggedInCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(with rootViewController: UINavigationController,
         credentials: Credentials) {
        navigationController = rootViewController
    }

    override func start() {
        guard let account = AccountManager.storedAccount else {
            die("LoggedInCoordinator.start() without Stored Account")
        }
        let vc = AccountViewController(with: account)
        navigationController.pushViewController(vc, animated: false)
    }
}
