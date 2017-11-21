//
//  OnboardingStartViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 10.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class OnboardingStartViewController: SeparatedViewController<OnboardingStartViewModel> {

    override func setup() {
        // Bind Outputs
        customView.newAccountButton.reactive.tap.bind(to: viewModel.createNewAccount)
            .dispose(in: disposeBag)
        customView.importMnemonicButton.reactive.tap.bind(to: viewModel.importMnemonicPhrase)
            .dispose(in: disposeBag)

        // Bind Inputs
        viewModel.newAccountButtonTitle.bind(to: customView.newAccountButton.reactive.title)
            .dispose(in: disposeBag)
        viewModel.enterMnemonicButtonTitle.bind(to: customView.importMnemonicButton.reactive.title)
            .dispose(in: disposeBag)
        viewModel.title.bind(to: reactive.title)
            .dispose(in: disposeBag)
    }
}
