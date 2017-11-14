//
//  LargeTitleNavigationController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 14.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

extension UINavigationController {
    static var largeTitleNavigationController: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
