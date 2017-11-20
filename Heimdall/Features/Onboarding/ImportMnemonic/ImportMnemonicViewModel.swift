//
//  ImportMnemonicViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class ImportMnemonicViewModel {
    let importButtonTitle = Property("ImportMnemonic.ViewController.ImportButton.Title".localized)
    let title = Property("ImportMnemonic.ViewController.Title".localized)
    let currentMnemonicPhrase = Property<String?>(nil)

    var importButtonTap: SafeSignal<Void>? {
        didSet {
            guard let signal = importButtonTap else {
                importMnemonicPhrase = nil
                return
            }
            importMnemonicPhrase = combineLatest(signal, currentMnemonicPhrase) { _, phrase in phrase ?? "" }
        }
    }
    var importMnemonicPhrase: SafeSignal<String>?
}
