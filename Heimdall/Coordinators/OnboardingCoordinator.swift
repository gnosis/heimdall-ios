//
//  OnboardingCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: class {
    func finishedOnboarding()
}

class OnboardingCoordinator: Coordinator {
    let navigationController: UINavigationController
    let credentialsStore: CredentialsStore
    weak var delegate: OnboardingCoordinatorDelegate?

    init(with rootViewController: UINavigationController,
         credentialsStore: CredentialsStore) {
        navigationController = rootViewController
        self.credentialsStore = credentialsStore
    }

    override func start() {
        let vc = OnboardingViewController()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func newAccountTapped() {
        let phrase = MnemonicPhrase.random
        let newVC = DisplayMnemonicViewController(mnemonicPhrase: phrase)
        newVC.delegate = self
        navigationController.pushViewController(newVC, animated: true)
    }

    func importMnemonicTapped() {
        let newVC = ImportMnemonicViewController(store: credentialsStore)
        newVC.delegate = self
        navigationController.pushViewController(newVC, animated: true)
    }
}

extension OnboardingCoordinator: DisplayMnemonicViewControllerDelegate {
    func gotItTapped() {
        let viewController = ImportMnemonicViewController(store: credentialsStore)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension OnboardingCoordinator: ImportMnemonicViewControllerDelegate {
    func importTapped(phrase: String) {
        guard let credentials = try? Credentials(from: phrase) else {
            // TODO: display error message somehow
            return
        }

        do {
            try self.credentialsStore.store(credentials: credentials)
        } catch {
            die("Could not store credentials")
        }

        delegate?.finishedOnboarding()
    }
}
