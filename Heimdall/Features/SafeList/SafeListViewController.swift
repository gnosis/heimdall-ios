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

class SafeListViewController: SeparatedViewController<SafeListViewModel>, UITableViewDelegate {
    enum Error: String, Swift.Error {
        case invalidCell
    }

    override func setup() {
        // Bind Inputs
        viewModel
            .items
            .bind(to: customView.tableView) { safeViewModels, indexPath, tableView -> UITableViewCell in
                let cellViewModel = safeViewModels[indexPath.row]
                guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: String(describing: ReactiveUITableViewCell.self))
                    as? ReactiveUITableViewCell,
                    let textLabel = cell.textLabel,
                    let detailTextLabel = cell.detailTextLabel else {
                        die(Error.invalidCell)
                }
                cellViewModel.textLabelText
                    .bind(to: textLabel)
                    .dispose(in: cell.reuseBag)
                cellViewModel.detailTextLabelText
                    .bind(to: detailTextLabel)
                    .dispose(in: cell.reuseBag)
                return cell
            }
            .dispose(in: disposeBag)
        viewModel
            .title
            .bind(to: reactive.title)
            .dispose(in: disposeBag)

        // Bind Outputs
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addItem
        addItem
            .reactive
            .tap
            .bind(to: viewModel.addSafeAction)
            .dispose(in: disposeBag)

        customView
            .tableView
            .reactive
            .selectedIndexPath
            .bind(to: viewModel.openIndexAction)
            .dispose(in: disposeBag)

        // Make sure we get the swipe action calls
        customView.tableView.reactive.delegate.forwardTo = self
    }

    // MARK: UITableViewDelegate
    // Easy method of swipe-to-delete, but this needs to be changed if we want
    // to support platforms below iOS11.
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let actions = [
                UIContextualAction(style: .destructive,
                                   title: "Shared.SwipeAction.Delete".localized) { (_, _, handler) in
                                    self.viewModel.deleteSafeAction.next(indexPath)
                                    handler(true)
                }
            ]
            return UISwipeActionsConfiguration(actions: actions)
    }
}
