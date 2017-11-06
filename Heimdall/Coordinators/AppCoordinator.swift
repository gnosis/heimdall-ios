//
//  AppCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 18.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class AppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow
    let secureStore = SecureDataStore()
    let credentialsRepo: CredentialsRepo

    init(with window: UIWindow) {
        self.window = window
        credentialsRepo = CredentialsRepo(store: secureStore)
    }

    override func start() -> SafeSignal<CoordinationResult> {
        if credentialsRepo.hasStoredCredentials,
            let credentials = try? credentialsRepo.fetchCredentials() {
            return coordinateLoggedIn(credentials: credentials)
        } else {
            let coordinator = OnboardingCoordinator(with: window,
                                                    credentialsRepo: credentialsRepo)
            return coordinate(to: coordinator)
                .flatMapLatest { self.coordinateLoggedIn(credentials: $0) }
        }
    }
}

extension AppCoordinator {
    func coordinateLoggedIn(credentials: Credentials) -> SafeSignal<Void> {
        let coordinator = LoggedInCoordinator(with: window,
                                              credentials: credentials)
        return coordinate(to: coordinator)
    }
}
