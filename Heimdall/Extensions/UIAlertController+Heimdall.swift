//
//  UIAlertController+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 22.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

extension UIAlertAction {
    static var reactiveCancel: (UIAlertAction, SafeSignal<UIAlertAction>) {
        return reactiveAction(title: "Shared.ButtonTitle.Cancel".localized, style: .cancel)
    }

    static func reactiveAction(title: String, style: UIAlertActionStyle) -> (UIAlertAction, SafeSignal<UIAlertAction>) {
        let subject = SafePublishSubject<UIAlertAction>()
        let handler = { (selectedAction: UIAlertAction) in
            subject.completed(with: selectedAction)
        }
        let action = UIAlertAction(title: title, style: style, handler: handler)
        return (action, subject.toSignal())
    }
}
