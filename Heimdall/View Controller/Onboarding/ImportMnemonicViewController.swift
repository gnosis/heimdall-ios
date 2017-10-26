//
//  ImportMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 11.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
import PureLayout

protocol ImportMnemonicViewControllerDelegate: class {
    func importTapped(phrase: String)
}

class ImportMnemonicViewController: UIViewController {
    let ui = ImportMnemonicViewControllerUI()
    let credentialsStore: CredentialsStore
    weak var delegate: ImportMnemonicViewControllerDelegate?

    init(store: CredentialsStore) {
        credentialsStore = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        title = "Enter Mnemonic Phrase"

        ui.importButton.addEventHandler { [weak self] in
            guard let `self` = self,
                let phrase = self.ui.mnemonicTextField.text else { return }
            self.delegate?.importTapped(phrase: phrase)
        }

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

    lazy var importButton = StyleKit.button(with: "Import")
}
