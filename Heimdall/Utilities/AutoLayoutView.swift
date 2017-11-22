//
//  AutoLayoutView.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

/// A UIView subclass that handles adding constraints automatically.
/// Override setupInitialConstraints/setupSubviews if you need to.
class AutoLayoutView: UIView, SeparatedView {
    // MARK: UIView Stuff
    var didSetupConstraints = false

    required init() {
        super.init(frame: .zero)
        backgroundColor = .schemeBackground
        tintColor = .websiteTint
        setupSubviews()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func updateConstraints() {
        defer {
            super.updateConstraints()
        }
        guard !didSetupConstraints else {
            return
        }
        setupInitialConstraints()
        didSetupConstraints = true
    }

    // MARK: SeparatedView Overridable
    /// Override if you need to add subviews to your subclass.
    func setupSubviews() {}

    /// Override to add constraints for your subviews.
    func setupInitialConstraints() {}

    /// Override if you want a rightBarButtonItem
    var rightBarButtonItem: UIBarButtonItem? {
        return nil
    }
}
