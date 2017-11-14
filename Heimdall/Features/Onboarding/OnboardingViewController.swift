//
//  OnboardingViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 10.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import PureLayout
import ReactiveKit
import UIKit

class OnboardingStartViewModel {
    // VM -> V
    let newAccountButtonTitle = Property("OnboardingStart.ViewController.NewAccountButton.Title".localized)
    let enterMnemonicButtonTitle = Property("OnboardingStart.ViewController.EnterMnemonicButton.Title".localized)
    let title = Property("OnboardingStart.ViewController.Title".localized)

    // VM -> Coord
    var createNewAccount: SafeSignal<Void>?
    var importMnemonicPhrase: SafeSignal<Void>?
}

class OnboardingViewController: UIViewController {
    let ui = OnboardingViewControllerUI()
    let viewModel: OnboardingStartViewModel

    init(viewModel: OnboardingStartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Bind Outputs
        viewModel.createNewAccount = ui.newAccountButton.reactive.tap
        viewModel.importMnemonicPhrase = ui.importMnemonicButton.reactive.tap

        // Bind Inputs
        viewModel.newAccountButtonTitle.bind(to: ui.newAccountButton.reactive.title)
        viewModel.enterMnemonicButtonTitle.bind(to: ui.importMnemonicButton.reactive.title)
        viewModel.title.bind(to: reactive.title)
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }

    override func loadView() {
        view = ui.view
    }
}

class OnboardingViewControllerUI: ViewControllerUI {
    lazy var view: UIView = {
        let view = StyleKit.controllerView()

        let newAccountButton = self.newAccountButton
        view.addSubview(newAccountButton)
        newAccountButton.autoAlignAxis(toSuperviewAxis: .vertical)
        newAccountButton.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        let importMnemonicButton = self.importMnemonicButton
        view.addSubview(importMnemonicButton)
        importMnemonicButton.autoAlignAxis(toSuperviewAxis: .vertical)
        importMnemonicButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 32)
        return view
    }()

    let newAccountButton = StyleKit.button(with: "")
    let importMnemonicButton = StyleKit.button(with: "")
}
