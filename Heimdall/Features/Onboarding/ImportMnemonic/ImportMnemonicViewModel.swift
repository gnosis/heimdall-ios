//
//  ImportMnemonicViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class ImportMnemonicViewModel: SeparatedViewModel {
    // MARK: SeparatedViewModel
    typealias View = ImportMnemonicView
    let title = Property<String?>("ImportMnemonic.ViewController.Title".localized)

    let disposeBag = DisposeBag()

    // MARK: Custom Stuff
    let importButtonTitle = Property("ImportMnemonic.ViewController.ImportButton.Title".localized)
    let currentMnemonicPhrase = Property<String?>(nil)
    let importButtonTap = SafePublishSubject<Void>()
    let importMnemonicPhrase = SafePublishSubject<String>()

    init() {
        combineLatest(importButtonTap, currentMnemonicPhrase) { _, phrase in phrase ?? "" }
            .bind(to: importMnemonicPhrase)
            .dispose(in: disposeBag)
    }
}
