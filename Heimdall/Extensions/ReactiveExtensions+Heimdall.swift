//
//  ReactiveExtensions+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

extension ReactiveExtensions where Base: UIViewController {
    /// The title of the view controller.
    var title: Bond<String?> {
        return bond { viewController, text in
            viewController.title = text
        }
    }
}
