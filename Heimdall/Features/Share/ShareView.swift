//
//  ShareView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 27.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class ShareView: AutoLayoutView {
    let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let shareButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: [])
        button.backgroundColor = .websiteTint
        return button
    }()
    let payloadLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textColor = .redTextColor
        label.backgroundColor = .labelBackground
        return label
    }()

    override func setupSubviews() {
        addSubview(qrCodeImageView)
        addSubview(shareButton)
        addSubview(payloadLabel)
    }

    override func setupInitialConstraints() {
        qrCodeImageView.autoPinEdge(toSuperviewEdge: .leading)
        qrCodeImageView.autoPinEdge(toSuperviewEdge: .trailing)
        qrCodeImageView.autoPinEdge(toSuperviewEdge: .top)
        qrCodeImageView.autoMatch(.height, to: .width, of: qrCodeImageView)

        payloadLabel.autoSetDimension(.height, toSize: 24 * 1.5)
        payloadLabel.autoPinEdge(toSuperviewMargin: .leading)
        payloadLabel.autoPinEdge(toSuperviewMargin: .trailing)
        payloadLabel.autoPinEdge(.top, to: .bottom, of: qrCodeImageView, withOffset: 24 * 1.5)

        shareButton.autoPinEdge(toSuperviewEdge: .leading)
        shareButton.autoPinEdge(toSuperviewEdge: .trailing)
        shareButton.autoPinEdge(toSuperviewEdge: .bottom)
        shareButton.autoSetDimension(.height, toSize: 42 * 1.5 + 2 * safeAreaInsets.bottom)
    }

    // MARK: SeparatedView
    let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: nil,
                                            action: nil)
    override var rightBarButtonItem: UIBarButtonItem? {
        return doneBarButtonItem
    }
}
