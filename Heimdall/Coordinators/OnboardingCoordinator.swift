//
//  OnboardingCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(with rootViewController: UINavigationController) {
        navigationController = rootViewController
    }
    
    override func start() {
        let vc = OnboardingViewController()
        navigationController.pushViewController(vc, animated: false)
    }
}
