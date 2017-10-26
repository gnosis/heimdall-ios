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
    let credentials: Credentials

    init(with rootViewController: UINavigationController,
         credentials: Credentials) {
        navigationController = rootViewController
        self.credentials = credentials
    }

    override func start() {
        let vc = AccountViewController(with: credentials)
        navigationController.pushViewController(vc, animated: false)
    }
}
