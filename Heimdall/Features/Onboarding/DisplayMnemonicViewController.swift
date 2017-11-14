//
//  DisplayMnemonicViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import PureLayout
import ReactiveKit
import UIKit

class DisplayMnemonicViewModel {
    let mnemonicLabelText: Property<String>
    let gotItButtonTitle = Property("DisplayMnemonic.ViewController.GotItButton.Title".localized)

    var gotIt: SafeSignal<Void>?

    init(phrase: String) {
        self.mnemonicLabelText = Property("DisplayMnemonic.ViewController.MnemonicLabel.Text".localized(phrase))
    }
}

class DisplayMnemonicViewController: UIViewController {
    let ui = DisplayMnemonicViewControllerUI()
    let viewModel: DisplayMnemonicViewModel

    init(viewModel: DisplayMnemonicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.mnemonicLabelText.bind(to: ui.mnemonicLabel.reactive.text)
        viewModel.gotItButtonTitle.bind(to: ui.gotItButton.reactive.title)

        viewModel.gotIt = ui.gotItButton.reactive.tap
    }

    required init?(coder aDecoder: NSCoder) { dieFromCoder() }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
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

    lazy var gotItButton: UIButton = {
        StyleKit.button(with: "")
    }()
}
