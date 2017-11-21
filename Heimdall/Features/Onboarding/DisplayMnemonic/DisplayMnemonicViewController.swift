//
//  DisplayMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

class DisplayMnemonicViewController: SeparatedViewController<DisplayMnemonicViewModel> {

    override func setup() {
        // Inputs
        viewModel
            .mnemonicLabelText
            .bind(to: customView.mnemonicLabel.reactive.text)
            .dispose(in: disposeBag)
        viewModel
            .gotItButtonTitle
            .bind(to: customView.gotItButton.reactive.title)
            .dispose(in: disposeBag)

        // Outputs
        customView
            .gotItButton
            .reactive
            .tap
            .bind(to: viewModel.gotIt)
            .dispose(in: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}
