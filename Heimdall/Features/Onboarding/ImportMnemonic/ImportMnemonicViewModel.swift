//
//  ImportMnemonicViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class ImportMnemonicViewModel {
    let disposeBag = DisposeBag()

    let importButtonTitle = Property("ImportMnemonic.ViewController.ImportButton.Title".localized)
    let title = Property("ImportMnemonic.ViewController.Title".localized)
    let currentMnemonicPhrase = Property<String?>(nil)

    let importButtonTap = SafePublishSubject<Void>()
    let importMnemonicPhrase = SafePublishSubject<String>()

    init() {
        combineLatest(importButtonTap, currentMnemonicPhrase) { _, phrase in phrase ?? "" }
            .bind(to: importMnemonicPhrase)
            .dispose(in: disposeBag)
    }
}
