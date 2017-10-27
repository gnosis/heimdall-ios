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

    private let onboardingFinishedSubject = SafePublishSubject<Credentials>()

    init(with window: UIWindow,
         credentialsStore: CredentialsStore) {
        self.window = window
        self.credentialsStore = credentialsStore
    }

    override func start() -> Signal<Credentials, NoError> {
        let onboardingStartViewModel = OnboardingStartViewModel()
        let onboardingStartViewController = OnboardingViewController(viewModel: onboardingStartViewModel)

        onboardingStartViewModel.createNewAccount?.observeNext { [weak self] _ in
            self?.newAccountTapped()
        }.dispose(in: disposeBag)

        onboardingStartViewModel.importMnemonicPhrase?.observeNext { [weak self] _ in
            self?.importMnemonicPhrase()
        }.dispose(in: disposeBag)

        navigationController.rootViewController = onboardingStartViewController

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return onboardingFinishedSubject.toSignal()
    }
}

extension OnboardingCoordinator {
    func newAccountTapped() {
        let phrase = MnemonicPhrase.random
        let viewModel = DisplayMnemonicViewModel(phrase: phrase)
        let viewController = DisplayMnemonicViewController(viewModel: viewModel)

        viewModel.gotIt?.observeNext { [weak self] _ in
            self?.importMnemonicPhrase()
        }.dispose(in: disposeBag)

        navigationController.pushViewController(viewController, animated: true)
    }

    func importMnemonicPhrase() {
        let viewModel = ImportMnemonicViewModel()
        let viewController = ImportMnemonicViewController(viewModel: viewModel)
        viewModel.importMnemonicPhrase?.observeNext { [weak self] phrase in
            self?.importTapped(phrase: phrase)
        }.dispose(in: disposeBag)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension OnboardingCoordinator {
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

        onboardingFinishedSubject.next(credentials)
        onboardingFinishedSubject.completed()
    }
}
