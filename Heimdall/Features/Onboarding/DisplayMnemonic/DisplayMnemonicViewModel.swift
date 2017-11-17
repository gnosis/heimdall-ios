//
//  DisplayMnemonicViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class DisplayMnemonicViewModel {
    let mnemonicLabelText: Property<String>
    let gotItButtonTitle = Property("DisplayMnemonic.ViewController.GotItButton.Title".localized)

    // FIXME: convert remaingin SafeSignal optionals, they suck
    var gotIt: SafeSignal<Void>?

    init(phrase: String) {
        self.mnemonicLabelText = Property("DisplayMnemonic.ViewController.MnemonicLabel.Text".localized(phrase))
    }
}
