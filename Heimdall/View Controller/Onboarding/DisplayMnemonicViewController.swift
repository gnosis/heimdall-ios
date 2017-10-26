//
//  DisplayMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
import PureLayout

protocol DisplayMnemonicViewControllerDelegate: class {
    func gotItTapped()
}

class DisplayMnemonicViewController: UIViewController {
    let ui = DisplayMnemonicViewControllerUI()
    let phrase: String
    weak var delegate: DisplayMnemonicViewControllerDelegate?

    init(mnemonicPhrase: String) {
        phrase = mnemonicPhrase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        die("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        ui.mnemonicLabel.text = """
            This is the mnemonic phrase that you can use to restore your account.
            Please write it down and store it safely.

            Phrase: \(phrase)
            """

        ui.gotItButton.addEventHandler { [weak self]  in
            guard let `self` = self else { return }
            self.delegate?.gotItTapped()
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
