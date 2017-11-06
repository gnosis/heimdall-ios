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

class LoggedInCoordinator: TabBarCoordinator {
    let credentials: Credentials
    let etherRpc: EtherRPC

    init(with window: UIWindow, credentials: Credentials) {
        self.credentials = credentials
        self.etherRpc = EtherRPC(provider: InfuraProvider(chainId: .ChainIdKovan,
                                                          accessToken: Secrets.infuraKey.rawValue),
                                 credentials: credentials,
                                 nonceProvider: NonceProvider())
        super.init(with: window)

        tabCoordinators = [AccountOverviewCoordinator(credentials: credentials, rpc: etherRpc),
                           TokenListCoordinator(credentials: credentials, rpc: etherRpc)]
    }
}
