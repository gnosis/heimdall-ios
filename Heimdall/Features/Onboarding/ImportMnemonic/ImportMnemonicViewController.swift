//
//  ImportMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 11.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

class ImportMnemonicViewController: SeparatedViewController<ImportMnemonicView> {
    let viewModel: ImportMnemonicViewModel

    init(viewModel: ImportMnemonicViewModel) {
        self.viewModel = viewModel
        super.init()

        // Bind Inputs
        viewModel
            .importButtonTitle
            .bind(to: customView.importButton.reactive.title)
            .dispose(in: disposeBag)
        viewModel
            .title
            .bind(to: reactive.title)
            .dispose(in: disposeBag)

        // Bind Outputs
        customView
            .mnemonicTextField
            .reactive
            .text
            .bidirectionalBind(to: viewModel.currentMnemonicPhrase)
            .dispose(in: disposeBag)
        customView.importButton.reactive.tap.bind(to: viewModel.importButtonTap)
            .dispose(in: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}
