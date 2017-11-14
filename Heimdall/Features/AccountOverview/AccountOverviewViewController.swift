//
//  AccountOverviewViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import PureLayout
import ReactiveKit
import UIKit

class AccountOverviewViewModel {
    let accountLabelText: Property<String>
    let balanceLabelText: Property<String>

    let title = Property("AccountOverview.ViewController.Title".localized)

    let disposeBag = DisposeBag()

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

class AccountOverviewViewController: UIViewController {
    let ui = AccountOverviewViewControllerUI()
    let viewModel: AccountOverviewViewModel

    init(viewModel: AccountOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Setup Bindings
        viewModel.accountLabelText.bind(to: ui.accountLabel.reactive.text)
        viewModel.balanceLabelText.bind(to: ui.balanceLabel.reactive.text)

        viewModel.title.bind(to: reactive.title)
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }

    override func loadView() {
        view = ui.view
    }
}

class AccountOverviewViewControllerUI: ViewControllerUI {
    lazy var view: UIView = {
        let view = StyleKit.controllerView()
        view.addSubview(self.accountLabel)
        self.accountLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .bottom)
        view.addSubview(self.balanceLabel)
        self.balanceLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
        self.balanceLabel.autoPinEdge(.top, to: .bottom, of: self.accountLabel)
        return view
    }()

    lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()

    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()
}
