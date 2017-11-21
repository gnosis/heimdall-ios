//
//  AccountOverviewViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

class AccountOverviewViewController: SeparatedViewController<AccountOverviewView> {
    init(viewModel: AccountOverviewViewModel) {
        super.init()

        // Setup Bindings
        viewModel.accountLabelText.bind(to: customView.accountLabel.reactive.text)
            .dispose(in: disposeBag)
        viewModel.balanceLabelText.bind(to: customView.balanceLabel.reactive.text)
            .dispose(in: disposeBag)

        viewModel.title.bind(to: reactive.title)
            .dispose(in: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }
}
