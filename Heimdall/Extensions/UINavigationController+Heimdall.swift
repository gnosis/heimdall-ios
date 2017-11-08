//
//  UINavigationController+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 27.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

extension UINavigationController {
    /// Returns the first view controller in the stack. Setting it resets the
    /// current navigation controller stack to only the new view controller,
    /// without any animations.
    var rootViewController: UIViewController? {
        get {
            return viewControllers.first
        }
        set {
            let array: [UIViewController]
            if let rootViewController = newValue {
                array = [rootViewController]
            } else {
                array = []
            }
            setViewControllers(array, animated: false)
        }
    }
}
