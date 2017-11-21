//
//  SafeDetailViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 20.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit

class SafeDetailViewModel {
    let title = Property("")

    let shareSafeAction = SafePublishSubject<Void>()

    init(safe: Safe) {
        title.value = safe.name ?? safe.address
    }
}

class SafeDetailView: AutoLayoutScrollView {
    required init() {
        super.init()
    }

    override func setupSubviews() {

    }

    override func setupInitialConstraints() {

    }
}

import UIKit

class SafeDetailViewController: SeparatedViewController<SafeDetailView> {
    let viewModel: SafeDetailViewModel

    init(viewModel: SafeDetailViewModel) {
        self.viewModel = viewModel
        super.init()

        viewModel.title.bind(to: reactive.title)

        let shareSafeButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        shareSafeButton.reactive.tap.debug().bind(to: viewModel.shareSafeAction)
        navigationItem.rightBarButtonItem = shareSafeButton

    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }
}
