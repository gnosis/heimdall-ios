//
//  TokenListViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 05.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import UIKit

class TokenListViewController: UIViewController {
    let tokenListView = TokenListView()
    let viewModel: TokenListViewModel

    init(viewModel: TokenListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Token List"
        viewModel.items.bind(to: tokenListView.tableView) { tokenViewModels, indexPath, _ -> UITableViewCell in
            let cellViewModel = tokenViewModels[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
            guard let textLabel = cell.textLabel,
                let detailTextLabel = cell.detailTextLabel else {
                    die("Invalid Cell")
            }
            cellViewModel.textLabelText.bind(to: textLabel.reactive.text)
            cellViewModel.detailTextLabelText.bind(to: detailTextLabel.reactive.text)
            return cell
        }

        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addItem
        viewModel.addToken = addItem.reactive.tap
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
