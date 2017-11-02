//
//  AccountViewController.swift
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
    let disposeBag = DisposeBag()

    init(credentials: Credentials, rpc: EtherRPC) {
        accountLabelText = Property("""
            This is your account.

            It has the address
                \(credentials.address)

            and the private key
                \(credentials.privateKey)
            """)
        balanceLabelText = Property("")
        rpc.balance(for: credentials.address)
            .map { "\($0.description) Ξ" }
            .suppressError(logging: true)
            .bind(to: balanceLabelText)
            .dispose(in: disposeBag)
    }
}

class AccountViewController: UIViewController {
    let ui = AccountViewControllerUI()
    let viewModel: AccountOverviewViewModel

    init(viewModel: AccountOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Setup Bindings
        viewModel.accountLabelText.bind(to: ui.accountLabel.reactive.text)
        viewModel.balanceLabelText.bind(to: ui.balanceLabel.reactive.text)
    }

    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func loadView() {
        view = ui.view
    }
}

class AccountViewControllerUI: ViewControllerUI {
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
