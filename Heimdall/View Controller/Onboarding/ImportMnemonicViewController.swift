//
//  ImportMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 11.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
// FIXME: this import should not be here
import ethers
import PureLayout

class ImportMnemonicViewController: UIViewController {
    let ui = ImportMnemonicViewControllerUI()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        title = "Enter Mnemonic Phrase"
        
        ui.importButton.addEventHandler { [weak self] in
            guard let `self` = self,
                let phrase = self.ui.mnemonicTextField.text,
                Account.isValidMnemonicPhrase(phrase) else { return }
            let account = AccountManager.account(from: phrase)
            AccountManager.store(account: account)
            // FIXME: bla bla router
            let viewController = AccountViewController(with: account)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let window = appDelegate.window else { return }
            window.rootViewController = viewController
        }
        
    }
    
    override func loadView() {
        view = ui.view
    }
}

class ImportMnemonicViewControllerUI: ViewControllerUI {
    lazy var view: UIView = {
        let view = StyleKit.controllerView()
        let mnemonicTextField = self.mnemonicTextField
        view.addSubview(mnemonicTextField)
        mnemonicTextField.autoPinEdge(toSuperviewEdge: .leading)
        mnemonicTextField.autoPinEdge(toSuperviewEdge: .trailing)
        mnemonicTextField.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        mnemonicTextField.autoSetDimension(.height, toSize: 200)
        let importButton = self.importButton
        view.addSubview(importButton)
        importButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
        importButton.autoPinEdge(.top, to: .bottom, of: mnemonicTextField, withOffset: 32)
        return view
    }()
    
    lazy var mnemonicTextField: UITextView = {
        let field = UITextView()
        field.backgroundColor = .schemeBackground
        field.tintColor = .websiteTint
        field.textColor = .white
        field.font = .systemFont(ofSize: 24)
        return field
    }()
    
    lazy var importButton = StyleKit.button(with: "Import")
}
