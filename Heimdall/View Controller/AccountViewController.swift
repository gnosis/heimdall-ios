//
//  AccountViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
// TODO: these imports should not be here, viewmodel and stuff
import ethers
import PureLayout

class AccountViewController: UIViewController {
    let ui = AccountViewControllerUI()
    // FIXME: change to wrapper class or something, in case we switch from ethers lib
    let account: Account
    
    init(with anAccount: Account) {
        account = anAccount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ui.accountLabel.text = "This is your account. It has the address: \(account.address) and the private key: \(account.privateKey)"
    }
    
    override func loadView() {
        view = ui.view
    }
}

class AccountViewControllerUI: ViewControllerUI {
    lazy var view: UIView = {
        let view = StyleKit.controllerView()
        view.addSubview(self.accountLabel)
        self.accountLabel.autoPinEdgesToSuperviewMargins()
        return view
    }()
    
    lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()
}
