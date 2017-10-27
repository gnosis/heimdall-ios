//
//  OnboardingCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class OnboardingCoordinator: BaseCoordinator<Credentials> {
    let window: UIWindow
    let credentialsStore: CredentialsStore
    let navigationController = UINavigationController()

    let testReturnSubject = SafePublishSubject<Credentials>()

    init(with window: UIWindow,
         credentialsStore: CredentialsStore) {
        self.window = window
        self.credentialsStore = credentialsStore
    }

    override func start() -> Signal<Credentials, NoError> {
        let onboardingStartViewController = OnboardingViewController()
        onboardingStartViewController.delegate = self
        navigationController.rootViewController = onboardingStartViewController

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return testReturnSubject.toSignal()
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

        testReturnSubject.next(credentials)
    }
}
