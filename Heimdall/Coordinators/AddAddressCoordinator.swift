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

// TODO: Make alert texts configurable ("enter address"/"enter token address")
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

        let alert = UIAlertController(title: "AddAddress.SelectMethod.Alert.Title".localized,
                                      message: "AddAddress.SelectMethod.Alert.Message".localized,
                                      preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Shared.ButtonTitle.Cancel".localized, style: .cancel) { _ in
            subject.completed(with: .cancel)
        }
        let qrCodeAction = UIAlertAction(
            title: "AddAddress.SelectMethod.Alert.ScanQrButton.Title".localized,
            style: .default) { _ in
                subject.completed(with: .scanQrCode)
        }
        let textAction = UIAlertAction(
            title: "AddAddress.SelectMethod.Alert.EnterAddressButton.Title".localized,
            style: .default) { _ in
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

        let alert = UIAlertController(title: "AddAddress.EnterAddress.Alert.Title".localized,
                                      message: "AddAddress.EnterAddress.Alert.Message".localized,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "AddAddress.EnterAddress.Alert.AddressTextField.Placeholder".localized
        }

        let addAction = UIAlertAction(
            title: "AddAddress.EnterAddress.Alert.ConfirmButton.Title".localized,
            style: .default) { _ in
                guard let textFields = alert.textFields,
                    textFields.count == 1,
                    let addressString = textFields[0].text,
                    !addressString.isEmpty else {
                        return
                }
                // Fetch token info
                subject.completed(with: .address(addressString))
        }
        let cancelAction = UIAlertAction(title: "Shared.ButtonTitle.Cancel".localized, style: .cancel) { _ in
            subject.completed(with: .cancel)
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true)
        return subject.toSignal()
    }
}
