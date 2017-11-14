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

class TokenListViewController: UIViewController {
    enum Error: String, Swift.Error {
        case invalidCell
    }

    let tokenListView = TokenListView()
    let viewModel: TokenListViewModel

    init(viewModel: TokenListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Bind Inputs
        viewModel.items.bind(to: tokenListView.tableView) { tokenViewModels, indexPath, tableView -> UITableViewCell in
            let cellViewModel = tokenViewModels[indexPath.row]
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: String(describing: ReactiveUITableViewCell.self))
                as? ReactiveUITableViewCell,
                let textLabel = cell.textLabel,
                let detailTextLabel = cell.detailTextLabel else {
                    die(Error.invalidCell)
            }
            cellViewModel.textLabelText
                .bind(to: textLabel.reactive.text).dispose(in: cell.reuseBag)
            cellViewModel.detailTextLabelText
                .bind(to: detailTextLabel.reactive.text).dispose(in: cell.reuseBag)
            return cell
        }
        // Make sure we get the swipe action calls
        tokenListView.tableView.reactive.delegate.forwardTo = self
        viewModel.title.bind(to: reactive.title)

        // Bind refresh control to display & trigger viewmodel refreshing
        viewModel.refreshing.bidirectionalBind(to: tokenListView.refreshControl.reactive.refreshing)

        // Bind Outputs
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addItem
        addItem.reactive.tap.bind(to: viewModel.addToken)
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }

    override func loadView() {
        view = tokenListView
    }
}

extension TokenListViewController: UITableViewDelegate {
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
