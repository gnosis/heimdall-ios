//
//  SafeListViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 05.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class SafeListViewController: SeparatedViewController<SafeListView>, UITableViewDelegate {
    let viewModel: SafeListViewModel

    init(viewModel: SafeListViewModel) {
        self.viewModel = viewModel
        super.init()

        // Bind Inputs
        viewModel.items.bind(to: customView.tableView) { safeViewModels, indexPath, tableView -> UITableViewCell in
            let cellViewModel = safeViewModels[indexPath.row]
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: String(describing: ReactiveUITableViewCell.self))
                as? ReactiveUITableViewCell,
                let textLabel = cell.textLabel,
                let detailTextLabel = cell.detailTextLabel else {
                    die("Invalid Cell")
            }
            cellViewModel.textLabelText
                .bind(to: textLabel)
                .dispose(in: cell.reuseBag)
            cellViewModel.detailTextLabelText
                .bind(to: detailTextLabel)
                .dispose(in: cell.reuseBag)
            return cell
        }
        // Make sure we get the swipe action calls
        customView.tableView.reactive.delegate.forwardTo = self
        viewModel.title.bind(to: reactive.title)

        // Bind Outputs
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addItem
        addItem.reactive.tap.bind(to: viewModel.addSafe)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDelegate
    // Easy method of swipe-to-delete, but this needs to be changed if we want
    // to support platforms below iOS11.
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let actions = [
                UIContextualAction(style: .destructive,
                                   title: "Delete") { (_, _, handler) in
                                    self.viewModel.deleteSafe.next(indexPath)
                                    handler(true)
                }
            ]
            return UISwipeActionsConfiguration(actions: actions)
    }
}
