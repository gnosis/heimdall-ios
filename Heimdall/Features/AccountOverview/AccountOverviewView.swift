//
//  AccountOverviewView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class AccountOverviewView: AutoLayoutView {
    let accountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()

    override func setupSubviews() {
        addSubview(accountLabel)
        addSubview(balanceLabel)
    }

    override func setupInitialConstraints() {
        accountLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .bottom)
        balanceLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
        balanceLabel.autoPinEdge(.top, to: .bottom, of: accountLabel)
    }
}
