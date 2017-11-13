//
//  SeparatedViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 13.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class SeparatedViewController<ViewType: AutoLayoutView>: UIViewController {
    let customView = ViewType()

    required init?(coder aDecoder: NSCoder) { die("init(coder:) has not been implemented") }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = customView
    }
}
