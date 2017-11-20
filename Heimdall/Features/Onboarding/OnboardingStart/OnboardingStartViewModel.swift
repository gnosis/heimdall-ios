//
//  OnboardingStartViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 14.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class OnboardingStartViewModel {
    // VM -> V
    let newAccountButtonTitle = Property("OnboardingStart.ViewController.NewAccountButton.Title".localized)
    let enterMnemonicButtonTitle = Property("OnboardingStart.ViewController.EnterMnemonicButton.Title".localized)
    let title = Property("OnboardingStart.ViewController.Title".localized)

    // VM -> Coord
    var createNewAccount: SafeSignal<Void>?
    var importMnemonicPhrase: SafeSignal<Void>?
}
