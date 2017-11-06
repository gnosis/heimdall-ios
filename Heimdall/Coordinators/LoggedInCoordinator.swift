//
//  LoggedInCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ethers
import ReactiveKit
import UIKit

class LoggedInCoordinator: BaseCoordinator<Void> {
    let window: UIWindow
    let credentials: Credentials
    let etherRpc: EtherRPC

    init(with window: UIWindow, credentials: Credentials) {
        self.window = window
        self.credentials = credentials
        self.etherRpc = EtherRPC(provider: InfuraProvider(chainId: .ChainIdKovan,
                                                          accessToken: Secrets.infuraKey.rawValue),
                                 credentials: credentials,
                                 nonceProvider: NonceProvider())
    }

    override func start() -> Signal<Void, NoError> {
        let accountViewModel = AccountOverviewViewModel(credentials: credentials, rpc: etherRpc)
        let accountViewController = AccountOverviewViewController(viewModel: accountViewModel)
        let navigationController = UINavigationController(rootViewController: accountViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Signal.never()
    }
}
