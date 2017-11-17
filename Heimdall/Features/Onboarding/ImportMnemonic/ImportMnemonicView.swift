//
//  ImportMnemonicView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import PureLayout

class ImportMnemonicView: AutoLayoutView {
    let mnemonicTextField: UITextView = {
        let field = UITextView()
        field.backgroundColor = .accentBackground
        field.tintColor = .websiteTint
        field.textColor = .white
        field.font = .systemFont(ofSize: 24)
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()

    let importButton = StyleKit.button(with: "")

    override func setupSubviews() {
        addSubview(mnemonicTextField)
        addSubview(importButton)
    }

    override func setupInitialConstraints() {
        mnemonicTextField.autoPinEdge(toSuperviewMargin: .leading)
        mnemonicTextField.autoPinEdge(toSuperviewMargin: .trailing)
        mnemonicTextField.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        mnemonicTextField.autoSetDimension(.height, toSize: 200)
        importButton.autoAlignAxis(toSuperviewAxis: .vertical)
        importButton.autoPinEdge(.top, to: .bottom, of: mnemonicTextField, withOffset: 16)
    }
}
