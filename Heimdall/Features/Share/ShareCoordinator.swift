//
//  ShareCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 22.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import CoreImage
import ReactiveKit
import UIKit

class ShareCoordinator: BaseCoordinator<Void> {
    private let rootViewController: UIViewController
    private let payload: String
    // PublishSubject kept around to prevent disposing of signal.
    private let publishSubject = SafePublishSubject<Void>()

    init(payload: String, rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        // TODO: Make payload a protocol like `ShareableModel`?
        self.payload = payload
        super.init()
    }

    override func start() -> Signal<Void, NoError> {
        let shareViewModel = ShareViewModel(payload: payload)
        let navigationController = UINavigationController.largeTitleNavigationController
        let shareViewController = ShareViewController(viewModel: shareViewModel)
        navigationController.rootViewController = shareViewController

        shareViewModel.closeShareAction
            .bind(to: self) { me, _ in
                navigationController.dismiss(animated: true)
                me.publishSubject.completed(with: ())
            }
            .dispose(in: bag)

        rootViewController.present(navigationController, animated: true)

        // TODO: maybe return actual share result (e.g. which method)
        return publishSubject.toSignal()
    }
}
