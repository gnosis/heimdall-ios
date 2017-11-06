//
//  TabCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class TabCoordinator: BaseCoordinator<Void> {
    let navigationController = UINavigationController()

    var tabBarItem: UITabBarItem {
        die("TabCoordinator.tabBarItem needs to be overridden.")
    }

    override init() {
        super.init()
        navigationController.tabBarItem = tabBarItem
    }
}
