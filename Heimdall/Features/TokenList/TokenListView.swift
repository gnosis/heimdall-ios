//
//  TokenListView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class TokenListView: AutoLayoutView {
    let tableView = UITableView()

    override func setupSubviews() {
        addSubview(tableView)
    }

    override func setupInitialConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
}
