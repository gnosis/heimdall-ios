//
//  DisplayMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

class DisplayMnemonicViewController: SeparatedViewController<DisplayMnemonicView> {
    let viewModel: DisplayMnemonicViewModel

    init(viewModel: DisplayMnemonicViewModel) {
        self.viewModel = viewModel
        super.init()

        viewModel.mnemonicLabelText.bind(to: customView.mnemonicLabel.reactive.text)
        viewModel.gotItButtonTitle.bind(to: customView.gotItButton.reactive.title)

        viewModel.gotIt = customView.gotItButton.reactive.tap
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }
}
