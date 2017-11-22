//
//  ShareQRCodeCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 22.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class ShareQRCodeCoordinator: BaseCoordinator<Void> {
    let rootViewController: UIViewController
    let title: String
    let payload: String

    init(title: String, payload: String, rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.title = title
        self.payload = payload
        super.init()
    }

    override func start() -> Signal<Void, NoError> {
        let alertController = UIAlertController(title: title,
                                                message: "Share Payload: \(payload)",
                                                preferredStyle: .alert)
        let (action, signal) = UIAlertAction.reactiveCancel
        alertController.addAction(action)
        rootViewController.present(alertController, animated: true)
        return signal.map { _ in }
    }
}
