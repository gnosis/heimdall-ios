//
//  StyleKit.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 11.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit

struct StyleKit {
    static func controllerView() -> UIView {
        let view = UIView()
        view.tintColor = .websiteTint
        view.backgroundColor = .schemeBackground
        return view
    }
    
    static func button(with title: String) -> ClosureButton {
        let button = ClosureButton(type: .system)
        button.setTitle(title, for: .normal)
        return button
    }
}

extension UIColor {
    @nonobjc static var websiteTint = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.768627451, alpha: 1)
    @nonobjc static var websiteBackground = #colorLiteral(red: 0.09411764706, green: 0.1647058824, blue: 0.2117647059, alpha: 1)
    @nonobjc static var schemeBackground = #colorLiteral(red: 0.8238534331, green: 0.8124054074, blue: 0.7747293711, alpha: 1)
}
