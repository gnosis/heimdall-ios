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
    let refreshControl = UIRefreshControl()
    let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func setupSubviews() {
        addSubview(tableView)
        tableView.register(ReactiveUITableViewCell.self,
                           forCellReuseIdentifier: String(describing: ReactiveUITableViewCell.self))
        tableView.refreshControl = refreshControl
    }

    override func setupInitialConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }

    // MARK: SeparatedView
    override var rightBarButtonItem: UIBarButtonItem? {
        return addItem
    }
}
