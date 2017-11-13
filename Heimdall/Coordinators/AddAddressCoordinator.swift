//
//  AddAddressCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import QRCodeReader
import ReactiveKit
import UIKit

enum AddAddressCoordinatorResult {
    case cancel
    case address(String)
}

private enum SelectMethodResult {
    case enterAddress
    case scanQrCode
    case cancel
}

class AddAddressCoordinator: BaseCoordinator<AddAddressCoordinatorResult> {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() -> Signal<CoordinationResult, NoError> {
        return showSelectMethodAlert()
            .flatMapLatest { result -> SafeSignal<CoordinationResult> in
                switch result {
                case .cancel:
                    return Signal.just(.cancel)
                case .enterAddress:
                    return self.showEnterAddressAlert()
                case .scanQrCode:
                    return self.showQrCodeFlow()
                }
        }
    }
}

private extension AddAddressCoordinator {
    func showQrCodeFlow() -> SafeSignal<CoordinationResult> {
        return ScanQRCodeCoordinator(rootViewController: navigationController)
            .start()
            .map { result in
                switch result {
                case .cancel:
                    return .cancel
                case .qrCode(let value):
                    return .address(value)
                }
        }
    }

    func showSelectMethodAlert() -> SafeSignal<SelectMethodResult> {
        let subject = SafePublishSubject<SelectMethodResult>()

        let alert = UIAlertController(title: "Select Method",
                                      message: "How would you like to add a token",
                                      preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            subject.completed(with: .cancel)
        }
        let qrCodeAction = UIAlertAction(title: "Scan QR Code", style: .default) { _ in
            subject.completed(with: .scanQrCode)
        }
        let textAction = UIAlertAction(title: "Enter Address", style: .default) { _ in
            subject.completed(with: .enterAddress)
        }
        alert.addAction(qrCodeAction)
        alert.addAction(textAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true)
        return subject.toSignal()
    }

    func showEnterAddressAlert() -> SafeSignal<CoordinationResult> {
        let subject = SafePublishSubject<CoordinationResult>()

        let alert = UIAlertController(title: "Add Token",
                                      message: "Enter your token's address",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Address"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textFields = alert.textFields,
                textFields.count == 1,
                let addressString = textFields[0].text,
                !addressString.isEmpty else {
                    return
            }
            // Fetch token info
            subject.completed(with: .address(addressString))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            subject.completed(with: .cancel)
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true)
        return subject.toSignal()
    }
}
