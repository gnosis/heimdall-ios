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

    static func button(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        return button
    }
}

extension UIColor {
    @nonobjc static let websiteTint = #colorLiteral(red: 0, green: 0.6509803922, blue: 0.768627451, alpha: 1)
    @nonobjc static let websiteBackground = #colorLiteral(red: 0.09411764706, green: 0.1647058824, blue: 0.2117647059, alpha: 1)
    @nonobjc static let schemeBackground = #colorLiteral(red: 0.8238534331, green: 0.8124054074, blue: 0.7747293711, alpha: 1)
    @nonobjc static let accentBackground = #colorLiteral(red: 0.7546566332, green: 0.7621284811, blue: 0.7621284811, alpha: 1)
    @nonobjc static let redTextColor = #colorLiteral(red: 0.9647058824, green: 0.2509803922, blue: 0.337254902, alpha: 1)
    @nonobjc static let labelBackground = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9764705882, alpha: 1)
}
