//
//  OnboardingViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 10.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class OnboardingStartViewController: SeparatedViewController<OnboardingStartView> {
    let viewModel: OnboardingStartViewModel

    init(viewModel: OnboardingStartViewModel) {
        self.viewModel = viewModel
        super.init()

        // Bind Outputs
        viewModel.createNewAccount = customView.newAccountButton.reactive.tap
        viewModel.importMnemonicPhrase = customView.importMnemonicButton.reactive.tap

        // Bind Inputs
        viewModel.newAccountButtonTitle.bind(to: customView.newAccountButton.reactive.title)
        viewModel.enterMnemonicButtonTitle.bind(to: customView.importMnemonicButton.reactive.title)
        viewModel.title.bind(to: reactive.title)
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }
}
