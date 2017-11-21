//
//  SafeDetailViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 20.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit

class SafeDetailViewModel: SeparatedViewModel {
    typealias View = SafeDetailView

    let title = Property<String?>("")
    let shareSafeAction = SafePublishSubject<Void>()

    init(safe: Safe) {
        title.value = safe.name ?? safe.address
    }
}

class SafeDetailView: AutoLayoutScrollView {
    required init() {
        super.init()
    }

    override func setupSubviews() {}
    override func setupInitialConstraints() {}
}

import UIKit

class SafeDetailViewController: SeparatedViewController<SafeDetailViewModel> {
    override func setup() {
        viewModel.title.bind(to: reactive.title)

        let shareSafeButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        shareSafeButton.reactive.tap.debug().bind(to: viewModel.shareSafeAction)
        navigationItem.rightBarButtonItem = shareSafeButton
    }
}
