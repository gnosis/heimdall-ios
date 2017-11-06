//
//  TabBarCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class TabBarCoordinator: BaseCoordinator<Void> {
    let window: UIWindow
    let tabBarController = UITabBarController()

    init(with window: UIWindow) {
        self.window = window
        super.init()
    }

    var tabCoordinators: [TabCoordinator] = []

    override func start() -> Signal<Void, NoError> {
        guard !tabCoordinators.isEmpty else {
            die("TabBarCoordinator.tabCoordinators is empty. Needs to be set by subclass before .start() is called.")
        }

        tabBarController.viewControllers = tabCoordinators.map { $0.navigationController }
        tabCoordinators.forEach {
            $0.start().observeNext {}.dispose(in: disposeBag)
        }

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        return Signal.never()
    }
}
