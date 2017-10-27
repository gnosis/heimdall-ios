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
    let credentialsStore: CredentialsStore

    init(with window: UIWindow) {
        self.window = window
        credentialsStore = CredentialsStore(store: secureStore)
    }

    override func start() -> SafeSignal<CoordinationResult> {
        if credentialsStore.hasStoredCredentials,
            let credentials = try? credentialsStore.fetchCredentials() {
            return coordinateLoggedIn(credentials: credentials)
        } else {
            let coordinator = OnboardingCoordinator(with: window,
                                                    credentialsStore: credentialsStore)
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
