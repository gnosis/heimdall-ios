//
//  ShareViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 27.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

class ShareViewController: SeparatedViewController<ShareViewModel> {
    override func setup() {
        edgesForExtendedLayout = []

        customView.doneBarButtonItem.reactive.tap
            .bind(to: viewModel.closeShareAction)
        customView.shareButton.reactive.tap
            .bind(to: viewModel.shareAction)
        customView.payloadLabel.reactive.tapGesture().map { _ in }
            .bind(to: viewModel.shareAction)

        viewModel.qrCodeImage.bind(to: customView.qrCodeImageView)
        viewModel.shareButtonTitle.bind(to: customView.shareButton.reactive.title)
        viewModel.payloadLabelText.bind(to: customView.payloadLabel)
    }
}
