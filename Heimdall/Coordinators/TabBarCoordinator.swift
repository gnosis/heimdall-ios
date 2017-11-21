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
    enum Error: String, Swift.Error {
        case tabCoordinatorsAreEmpty = """
            TabBarCoordinator.tabCoordinators is empty. Needs to be set by subclass before .start() is called.
            """
    }

    let window: UIWindow
    let tabBarController = UITabBarController()
    var tabCoordinators: [TabCoordinator] = []

    init(with window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start() -> Signal<Void, NoError> {
        guard !tabCoordinators.isEmpty else {
            die(Error.tabCoordinatorsAreEmpty)
        }

        tabBarController.viewControllers = tabCoordinators.map { $0.navigationController }
        tabCoordinators.forEach {
            $0.start().observeNext {}.dispose(in: bag)
        }

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        return Signal.never()
    }
}
