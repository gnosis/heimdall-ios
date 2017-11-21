//
//  DisplayMnemonicViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class DisplayMnemonicViewModel: SeparatedViewModel {
    // MARK: SeparatedViewModel
    typealias View = DisplayMnemonicView
    let title = Property<String?>(nil)

    // MARK: Custom Stuff
    let mnemonicLabelText: Property<String>
    let gotItButtonTitle = Property("DisplayMnemonic.ViewController.GotItButton.Title".localized)
    let gotIt = SafePublishSubject<Void>()

    init(phrase: String) {
        self.mnemonicLabelText = Property("DisplayMnemonic.ViewController.MnemonicLabel.Text".localized(phrase))
    }
}
