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
    let tokenListView = TokenListView()
    let viewModel: TokenListViewModel

    let deleteItemSubject = SafePublishSubject<IndexPath>()

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
                    die("Invalid Cell")
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

        // Bind Outputs
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addItem
        viewModel.addToken = addItem.reactive.tap
        viewModel.deleteToken = deleteItemSubject.toSignal()
    }

    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

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
                                   title: "Delete") { (_, _, handler) in
                                    self.deleteItemSubject.next(indexPath)
                                    handler(true)
                }
            ]
            return UISwipeActionsConfiguration(actions: actions)
    }
}
