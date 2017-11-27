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

        viewModel.qrCodeImage.bind(to: customView.qrCodeImageView)
    }
}
