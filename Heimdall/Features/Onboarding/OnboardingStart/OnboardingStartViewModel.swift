//
//  OnboardingStartViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 14.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class OnboardingStartViewModel: SeparatedViewModel {
    // MARK: SeparatedViewModel
    typealias View = OnboardingStartView
    let title = Property<String?>("OnboardingStart.ViewController.Title".localized)

    // MARK: Custom Stuff
    // VM -> V
    let newAccountButtonTitle = Property("OnboardingStart.ViewController.NewAccountButton.Title".localized)
    let enterMnemonicButtonTitle = Property("OnboardingStart.ViewController.EnterMnemonicButton.Title".localized)

    // VM -> Coord
    var createNewAccount = SafePublishSubject<Void>()
    var importMnemonicPhrase = SafePublishSubject<Void>()
}
