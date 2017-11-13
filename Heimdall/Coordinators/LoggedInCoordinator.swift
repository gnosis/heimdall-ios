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
    init(with window: UIWindow,
         credentials: Credentials,
         networkingProvider: NetworkingProvider) {
        let etherRpc = EtherRPC(provider: networkingProvider.rpcProvider,
                                credentials: credentials,
                                nonceProvider: networkingProvider.nonceProvider)
        super.init(with: window)

        let accountCoordinator = AccountOverviewCoordinator(credentials: credentials,
                                                            rpc: etherRpc)
        let tokenProvider = VerifiedTokenProvider(chainId: networkingProvider.chainId)
        let tokenListCoordinator = TokenListCoordinator(credentials: credentials,
                                                        rpc: etherRpc,
                                                        whiteListTokenProvider: tokenProvider)
        tabCoordinators = [accountCoordinator, tokenListCoordinator]
    }
}
