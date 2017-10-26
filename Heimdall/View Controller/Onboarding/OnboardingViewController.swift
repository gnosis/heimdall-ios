//
//  OnboardingViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 10.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
import PureLayout

protocol OnboardingViewControllerDelegate: class {
    func newAccountTapped()
    func importMnemonicTapped()
}

class OnboardingViewController: UIViewController {
    let ui = OnboardingViewControllerUI()
    weak var delegate: OnboardingViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        guard navigationController != nil else {
            die("OnboardingViewController presented without navigationController")
        }
        title = "Setup Account"

        ui.newAccountButton.addEventHandler { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.newAccountTapped()
        }
        ui.importMnemonicButton.addEventHandler { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.importMnemonicTapped()
        }
    }

    override func loadView() {
        view = ui.view
    }
}

class OnboardingViewControllerUI: ViewControllerUI {
    lazy var view: UIView = {
        let view = StyleKit.controllerView()

        let newAccountButton = self.newAccountButton
        view.addSubview(newAccountButton)
        newAccountButton.autoAlignAxis(toSuperviewAxis: .vertical)
        newAccountButton.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        let importMnemonicButton = self.importMnemonicButton
        view.addSubview(importMnemonicButton)
        importMnemonicButton.autoAlignAxis(toSuperviewAxis: .vertical)
        importMnemonicButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 32)
        return view
    }()

    // FIXME: strings
    let newAccountButton = StyleKit.button(with: "Create a new account")
    let importMnemonicButton = StyleKit.button(with: "Enter Mnemonic Phrase")
}
