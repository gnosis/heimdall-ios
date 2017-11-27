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
    let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)

    override func setupSubviews() {
        addSubview(qrCodeImageView)
    }
    override func setupInitialConstraints() {
        qrCodeImageView.autoPinEdgesToSuperviewMargins()
    }

    // MARK: SeparatedView
    override var rightBarButtonItem: UIBarButtonItem? {
        return doneBarButtonItem
    }
}
