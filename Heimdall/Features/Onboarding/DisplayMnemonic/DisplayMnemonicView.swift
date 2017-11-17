//
//  DisplayMnemonicView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class DisplayMnemonicView: AutoLayoutView {
    let mnemonicLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = .systemFont(ofSize: 24)
        return label
    }()

    let gotItButton = StyleKit.button(with: "")

    override func setupSubviews() {
        addSubview(mnemonicLabel)
        addSubview(gotItButton)
    }

    override func setupInitialConstraints() {
        mnemonicLabel.autoPinEdge(toSuperviewEdge: .leading)
        mnemonicLabel.autoPinEdge(toSuperviewEdge: .trailing)
        mnemonicLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 32)

        gotItButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 32)
        gotItButton.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}
