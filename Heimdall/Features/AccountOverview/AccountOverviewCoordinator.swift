//
//  AccountOverviewCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class AccountOverviewCoordinator: TabCoordinator {
    let credentials: Credentials
    let etherRpc: EtherRPC

    init(credentials: Credentials, rpc: EtherRPC) {
        self.credentials = credentials
        self.etherRpc = rpc
        super.init()
    }

    override var tabBarItem: UITabBarItem {
        return UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
    }

    override func start() -> Signal<Void, NoError> {
        let accountViewModel = AccountOverviewViewModel(credentials: credentials, rpc: etherRpc)
        let accountViewController = AccountOverviewViewController(viewModel: accountViewModel)
        navigationController.rootViewController = accountViewController
        return Signal.never()
    }
}
