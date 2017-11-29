//
//  SafeDetailViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 20.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

class SafeDetailViewController: SeparatedViewController<SafeDetailViewModel> {
    override func setup() {
        viewModel.title.bind(to: reactive.title)
            .dispose(in: disposeBag)
        customView.shareSafeButton.reactive.tap.bind(to: viewModel.shareSafeAction)
            .dispose(in: disposeBag)
    }
}
