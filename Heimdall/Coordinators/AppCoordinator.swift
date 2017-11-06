//
//  AppCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 18.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit
import ethers

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
//        let coordinator = LoggedInCoordinator(with: window,
//                                              credentials: credentials)
        let rpc = EtherRPC(provider: InfuraProvider(chainId: .ChainIdKovan,
                                                          accessToken: Secrets.infuraKey.rawValue),
                                 credentials: credentials,
                                 nonceProvider: NonceProvider())
        let coordinator = TokenListCoordinator(with: window, rpc: rpc)
        return coordinate(to: coordinator)
    }
}
