//
//  TabCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class TabCoordinator: BaseCoordinator<Void> {
    enum Error: String, Swift.Error {
        case tabBarItemNotOverridden = "TabCoordinator.tabBarItem needs to be overridden."
    }

    let navigationController: UINavigationController = .largeTitleNavigationController

    var tabBarItem: UITabBarItem {
        die(Error.tabBarItemNotOverridden)
    }

    override init() {
        super.init()
        navigationController.tabBarItem = tabBarItem
    }
}
