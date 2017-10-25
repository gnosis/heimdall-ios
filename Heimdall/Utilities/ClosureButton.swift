//
//  ClosureButton.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 23.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

class ClosureButton: UIButton {
    var closure: (() -> Void)? {
        didSet {
            if closure != nil {
                addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            }
        }
    }

    func addEventHandler(handler: @escaping (() -> Void)) {
        closure = handler
    }

    @objc
    func didTouchUpInside(sender: UIButton) {
        if let handler = closure {
            handler()
        }
    }
}
