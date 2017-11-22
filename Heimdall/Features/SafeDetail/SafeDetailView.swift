//
//  SafeDetailView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 21.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class SafeDetailView: AutoLayoutScrollView {
    let shareSafeButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)

    override var rightBarButtonItem: UIBarButtonItem? {
        return shareSafeButton
    }

//    override func setupSubviews() {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//
//
//    }
}
