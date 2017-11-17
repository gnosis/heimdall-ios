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
        viewModel.importButtonTitle.bind(to: customView.importButton.reactive.title)
        viewModel.title.bind(to: reactive.title)

        // Bind Outputs
        customView.mnemonicTextField.reactive.text.bidirectionalBind(to: viewModel.currentMnemonicPhrase)
        viewModel.importButtonTap = customView.importButton.reactive.tap
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}
