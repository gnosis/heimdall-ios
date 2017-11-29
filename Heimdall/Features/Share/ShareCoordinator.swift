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

protocol Shareable {
    var payload: String { get }
    var title: String { get }
}

extension Safe: Shareable {
    var payload: String {
        return address
    }
    
    var title: String {
        return name ?? "Safe.Share.PlaceholderTitle".localized
    }
}

class ShareCoordinator: BaseCoordinator<Void> {
    private let rootViewController: UIViewController
    private let shareable: Shareable
    // PublishSubject kept around to prevent disposing of signal.
    private let publishSubject = SafePublishSubject<Void>()

    init(shareable: Shareable, rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.shareable = shareable
        super.init()
    }

    override func start() -> Signal<Void, NoError> {
        let shareViewModel = ShareViewModel(shareable: shareable)
        let navigationController = UINavigationController()
        let shareViewController = ShareViewController(viewModel: shareViewModel)
        navigationController.rootViewController = shareViewController

        shareViewModel
            .closeShareAction
            .bind(to: self) { me, _ in
                navigationController.dismiss(animated: true)
                me.publishSubject.completed(with: ())
            }
            .dispose(in: bag)
        shareViewModel
            .shareAction
            .bind(to: self) { me, _ in
                let activityViewController = UIActivityViewController(activityItems: [me.shareable.payload], applicationActivities: nil)
                navigationController.present(activityViewController, animated: true)
            }
            .dispose(in: bag)

        rootViewController.present(navigationController, animated: true)
        // TODO: maybe return actual share result (e.g. which method)
        return publishSubject.toSignal()
    }
}
