//
//  AccountOverviewViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

class AccountOverviewViewModel: SeparatedViewModel {
    // MARK: SeparatedViewModel
    typealias View = AccountOverviewView
    let title = Property<String?>("AccountOverview.ViewController.Title".localized)

    // MARK: Custom Stuff
    let disposeBag = DisposeBag()

    let accountLabelText: Property<String>
    let balanceLabelText: Property<String>

    init(credentials: Credentials, rpc: EtherRPC) {
        accountLabelText = Property(
            "AccountOverview.ViewController.AccountLabel.Text"
                .localized(credentials.address, credentials.privateKey))
        balanceLabelText = Property("")
        rpc.balance(for: credentials.address)
            .map { $0.description }
            .suppressError(logging: true)
            .bind(to: balanceLabelText)
            .dispose(in: disposeBag)
    }
}
