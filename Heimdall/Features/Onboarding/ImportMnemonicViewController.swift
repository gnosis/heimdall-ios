//
//  ImportMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 11.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import PureLayout
import ReactiveKit
import UIKit

class ImportMnemonicViewModel {
    let importButtonTitle = Property("Import")
    let title = Property("Enter Mnemonic Phrase")
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

class ImportMnemonicViewController: UIViewController {
    let ui = ImportMnemonicViewControllerUI()
    let viewModel: ImportMnemonicViewModel

    init(viewModel: ImportMnemonicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Bind Inputs
        viewModel.importButtonTitle.bind(to: ui.importButton.reactive.title)
        viewModel.title.bind(to: reactive.title)

        // Bind Outputs
        ui.mnemonicTextField.reactive.text.bidirectionalBind(to: viewModel.currentMnemonicPhrase)
        viewModel.importButtonTap = ui.importButton.reactive.tap
    }

    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ui.view
    }
}

class ImportMnemonicViewControllerUI: ViewControllerUI {
    lazy var view: UIView = {
        let view = StyleKit.controllerView()
        let mnemonicTextField = self.mnemonicTextField
        view.addSubview(mnemonicTextField)
        mnemonicTextField.autoPinEdge(toSuperviewEdge: .leading)
        mnemonicTextField.autoPinEdge(toSuperviewEdge: .trailing)
        mnemonicTextField.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        mnemonicTextField.autoSetDimension(.height, toSize: 200)
        let importButton = self.importButton
        view.addSubview(importButton)
        importButton.autoAlignAxis(toSuperviewAxis: .vertical)

        importButton.autoPinEdge(.top, to: .bottom, of: mnemonicTextField, withOffset: 32)
        return view
    }()

    lazy var mnemonicTextField: UITextView = {
        let field = UITextView()
        field.backgroundColor = .schemeBackground
        field.tintColor = .websiteTint
        field.textColor = .white
        field.font = .systemFont(ofSize: 24)
        return field
    }()

    lazy var importButton = StyleKit.button(with: "")
}
