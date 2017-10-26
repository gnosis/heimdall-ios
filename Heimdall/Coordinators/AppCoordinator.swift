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
        if credentialsStore.hasStoredCredentials,
            let credentials = try? credentialsStore.fetchCredentials() {
            let coordinator = LoggedInCoordinator(with: navigationController,
                                                  credentials: credentials)
            add(coordinator)
            coordinator.start()
        } else {
            let coordinator = OnboardingCoordinator(with: navigationController,
                                                    credentialsStore: credentialsStore)
            coordinator.delegate = self
            add(coordinator)
            coordinator.start()
        }
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func finishedOnboarding() {
        start()
    }
}
