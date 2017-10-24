//
//  DisplayMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
// FIXME: this import should not be here
import ethers
import PureLayout

class DisplayMnemonicViewController: UIViewController {
    let ui = DisplayMnemonicViewControllerUI()
    let account: Account

    init(account anAccount: Account) {
        account = anAccount
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        guard let phrase = account.mnemonicPhrase else {
            die("DisplayMnemonicViewController presented with an account without mnemonic phrase")
        }
        ui.mnemonicLabel.text = "This is the mnemonic phrase that you can use to restore your account. Please write it down and store it safely.\nPhrase: \(phrase)"

        ui.gotItButton.addEventHandler { [weak self]  in
            guard let `self` = self else { return }
            let viewController = ImportMnemonicViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }

    }

    override func loadView() {
        view = ui.view
    }
}

class DisplayMnemonicViewControllerUI: ViewControllerUI {
    lazy var view: UIView = {
        let view = StyleKit.controllerView()
        let mnemonicLabel = self.mnemonicLabel
        view.addSubview(mnemonicLabel)
        mnemonicLabel.autoPinEdge(toSuperviewEdge: .leading)
        mnemonicLabel.autoPinEdge(toSuperviewEdge: .trailing)
        mnemonicLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 32)

        let gotItButton = self.gotItButton
        view.addSubview(gotItButton)
        gotItButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 32)
        gotItButton.autoAlignAxis(toSuperviewAxis: .vertical)
        return view
    }()

    lazy var mnemonicLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = .systemFont(ofSize: 24)
        return label
    }()

    lazy var gotItButton: ClosureButton = {
        StyleKit.button(with: "Got It")
    }()
}
