//
//  AddTokenCoordinator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

enum AddTokenCoordinatorResult {
    case cancel
    case token(Token)
}

class AddTokenCoordinator: BaseCoordinator<AddTokenCoordinatorResult> {
    let navigationController: UINavigationController
    let rpc: EtherRPC

    init(navigationController: UINavigationController, rpc: EtherRPC) {
        self.navigationController = navigationController
        self.rpc = rpc
    }

    override func start() -> Signal<CoordinationResult, NoError> {
        return showEnterAddressAlert()
            .flatMapLatest { result -> SafeSignal<CoordinationResult> in
                guard case .address(let address) = result else {
                    return Signal.just(CoordinationResult.cancel)
                }
                return self.rpc.tokenInfo(for: address).map { CoordinationResult.token($0) }
                    .flatMapError { _ -> SafeSignal<CoordinationResult> in
                        self.showEnterInfoAlert().map { result -> CoordinationResult in
                            guard case let .info(name, symbol, decimals) = result else {
                                return .cancel
                            }
                            let token = Token(address: address, name: name, symbol: symbol, decimals: decimals)
                            return .token(token)
                        }
                }
        }
    }
}

enum EnterAddressResult {
    case address(String)
    case cancel
}
enum EnterInfoResult {
    case info(name: String, symbol: String, decimals: Int)
    case cancel
}

private extension AddTokenCoordinator {
    func showEnterAddressAlert() -> SafeSignal<EnterAddressResult> {
        let subject = SafePublishSubject<EnterAddressResult>()

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

    func showEnterInfoAlert() -> SafeSignal<EnterInfoResult> {
        let subject = SafePublishSubject<EnterInfoResult>()

        let alert = UIAlertController(title: "Add Token",
                                      message: "Add some info here for tokens",
                                      preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Symbol"
        }
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Decimals"
            textField.keyboardType = .numberPad
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textFields = alert.textFields,
                textFields.count == 3,
                let symbol = textFields[0].text,
                let name = textFields[1].text,
                let decimalsString = textFields[2].text,
                let decimals = Int(decimalsString) else {
                    return
            }
            subject.completed(with: .info(name: name, symbol: symbol, decimals: decimals))
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
