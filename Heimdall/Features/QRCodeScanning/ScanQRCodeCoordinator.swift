//
//  ScanQRCodeCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 07.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import QRCodeReader
import ReactiveKit
import UIKit

enum ScanQRCodeCoordinatorResult {
    case cancel
    case qrCode(String)
}

class ScanQRCodeCoordinator: BaseCoordinator<ScanQRCodeCoordinatorResult> {
    let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init()
    }

    override func start() -> Signal<ScanQRCodeCoordinatorResult, NoError> {
        let subject = SafePublishSubject<ScanQRCodeCoordinatorResult>()

        let reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder() {
            $0.showSwitchCameraButton = false
        })
        reader.completionBlock = { result in
            reader.dismiss(animated: true)
            guard let result = result else {
                subject.completed(with: .cancel)
                return
            }
            let resultString = result.value
            subject.completed(with: .qrCode(resultString))
        }

        rootViewController.present(reader, animated: true)
        return subject.toSignal()
    }
}
