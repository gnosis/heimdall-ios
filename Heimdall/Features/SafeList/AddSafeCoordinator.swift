//
//  AddSafeCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 13.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

enum AddSafeCoordinatorResult {
    case cancel
    case safe(Safe)
}

class AddSafeCoordinator: BaseCoordinator<AddSafeCoordinatorResult> {
    let navigationController: UINavigationController
    let coordinator: AddAddressCoordinator

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.coordinator = AddAddressCoordinator(navigationController: navigationController)
    }

    override func start() -> Signal<CoordinationResult, NoError> {
        return coordinator.start()
            .flatMapLatest { result -> SafeSignal<CoordinationResult> in
                guard case .address(let address) = result else {
                    return Signal.just(.cancel)
                }
                return self.showEnterInfoAlert()
                    .map { result -> CoordinationResult in
                        guard case .info(let name) = result else {
                            return .cancel
                        }
                        return .safe(Safe(name: name, address: address))
                }
        }
    }
}

private enum EnterInfoResult {
    case info(name: String?)
    case cancel
}

private extension AddSafeCoordinator {
    func showEnterInfoAlert() -> SafeSignal<EnterInfoResult> {
        let subject = SafePublishSubject<EnterInfoResult>()

        let alert = UIAlertController(title: "Add Safe",
                                      message: "You can add a name if you wanna",
                                      preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Name"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textFields = alert.textFields,
                textFields.count == 1 else {
                    return
            }
            let textfieldContents = textFields[0].text
            // If the string is empty just use nil
            let name = textfieldContents.isNilOrEmpty ? nil : textfieldContents
            subject.completed(with: .info(name: name))
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
