//
//  TokenListViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 05.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class TokenListViewController: SeparatedViewController<TokenListViewModel> {
    enum Error: String, Swift.Error {
        case invalidCell
    }

    override func setup() {
        // Bind Inputs
        viewModel
            .items
            .bind(to: customView.tableView) { tokenViewModels, indexPath, tableView -> UITableViewCell in
                let cellViewModel = tokenViewModels[indexPath.row]
                guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: String(describing: ReactiveUITableViewCell.self))
                    as? ReactiveUITableViewCell,
                    let textLabel = cell.textLabel,
                    let detailTextLabel = cell.detailTextLabel else {
                        die(Error.invalidCell)
                }
                cellViewModel.textLabelText.bind(to: textLabel.reactive.text)
                    .dispose(in: cell.reuseBag)
                cellViewModel.detailTextLabelText.bind(to: detailTextLabel.reactive.text)
                    .dispose(in: cell.reuseBag)
                return cell
        }
        // Make sure we get the swipe action calls
        customView.tableView.reactive.delegate.forwardTo = self
        viewModel.title.bind(to: reactive.title)
            .dispose(in: disposeBag)

        // Bind refresh control to display & trigger viewmodel refreshing
        viewModel.refreshing.bidirectionalBind(to: customView.refreshControl.reactive.refreshing)
            .dispose(in: disposeBag)

        // Bind Outputs
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addItem
        addItem.reactive.tap.bind(to: viewModel.addToken)
            .dispose(in: disposeBag)
    }

    // MARK: UITableViewDelegate
    // This needs to be changed if we want to support devices below iOS11.
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let actions = [
                UIContextualAction(style: .destructive,
                                   title: "Shared.SwipeAction.Delete".localized) { (_, _, handler) in
                                    self.viewModel.deleteToken.next(indexPath)
                                    handler(true)
                }
            ]
            return UISwipeActionsConfiguration(actions: actions)
    }
}
