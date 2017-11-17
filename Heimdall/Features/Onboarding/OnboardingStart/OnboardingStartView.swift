//
//  OnboardingStartView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 14.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class OnboardingStartView: AutoLayoutScrollView {
    override func setupSubviews() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(newAccountButton)
        stackView.addArrangedSubview(importMnemonicButton)
        addSubview(stackView)
    }

    override func setupInitialConstraints() {
        stackView.autoPinEdgesToSuperviewEdges()
        let heightOffset = -1 * (safeAreaInsets.top + safeAreaInsets.bottom)
        let widthOffset = -1 * (safeAreaInsets.left + safeAreaInsets.right)

        stackView.autoMatch(.height, to: .height, of: self, withOffset: heightOffset)
        stackView.autoMatch(.width, to: .width, of: self, withOffset: widthOffset)
    }

    let newAccountButton = StyleKit.button(with: "")
    let importMnemonicButton = StyleKit.button(with: "")
    let stackView = UIStackView()
}
