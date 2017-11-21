//
//  OnboardingCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class OnboardingCoordinator: BaseCoordinator<Credentials> {
    let window: UIWindow
    let credentialsRepo: CredentialsRepo
    let navigationController: UINavigationController = .largeTitleNavigationController
    private let onboardingFinishedSubject = SafePublishSubject<Credentials>()

    init(with window: UIWindow,
         credentialsRepo: CredentialsRepo) {
        self.window = window
        self.credentialsRepo = credentialsRepo
    }

    override func start() -> Signal<Credentials, NoError> {
        let onboardingStartViewModel = OnboardingStartViewModel()
        let onboardingStartViewController = OnboardingStartViewController(viewModel: onboardingStartViewModel)

        onboardingStartViewModel.createNewAccount.bind(to: self) { mySelf, _ in
            mySelf.newAccountTapped()
        }

        onboardingStartViewModel.importMnemonicPhrase.bind(to: self) { mySelf, _ in
            mySelf.importMnemonicPhrase()
        }

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

        viewModel.gotIt.bind(to: self) { mySelf, _ in
            mySelf.importMnemonicPhrase()
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    func importMnemonicPhrase() {
        let viewModel = ImportMnemonicViewModel()
        let viewController = ImportMnemonicViewController(viewModel: viewModel)
        viewModel.importMnemonicPhrase.bind(to: self) { mySelf, phrase in
            mySelf.importTapped(phrase: phrase)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension OnboardingCoordinator {
    enum Error: String, Swift.Error {
        case couldNotStoreCredentials
    }

    func importTapped(phrase: String) {
        guard let credentials = try? Credentials(from: phrase) else {
            // TODO: display error message somehow
            return
        }

        do {
            try self.credentialsRepo.store(credentials: credentials)
        } catch {
            die(Error.couldNotStoreCredentials)
        }

        onboardingFinishedSubject.next(credentials)
        onboardingFinishedSubject.completed()
    }
}
