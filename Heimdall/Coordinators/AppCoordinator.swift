//
//  AppCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 18.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    let secureStore = SecureDataStore()
    let credentialsStore: CredentialsStore

    init(with rootViewController: UINavigationController) {
        navigationController = rootViewController
        credentialsStore = CredentialsStore(store: secureStore)
    }

    override func start() {
        if credentialsStore.hasStoredCredentials {
            let coordinator = LoggedInCoordinator(with: navigationController)
            add(coordinator)
            coordinator.start()
        } else {
            let coordinator = OnboardingCoordinator(with: navigationController)
            add(coordinator)
            coordinator.start()
        }
    }
}
