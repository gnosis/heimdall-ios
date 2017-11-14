//
//  SafeListView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class SafeListView: AutoLayoutView {
    let tableView = UITableView()

    override func setupSubviews() {
        addSubview(tableView)
        tableView.register(ReactiveUITableViewCell.self,
                           forCellReuseIdentifier: String(describing: ReactiveUITableViewCell.self))
    }

    override func setupInitialConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
}
