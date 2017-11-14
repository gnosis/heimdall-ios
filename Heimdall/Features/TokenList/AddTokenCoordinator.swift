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
    let coordinator: AddAddressCoordinator

    init(navigationController: UINavigationController, rpc: EtherRPC) {
        self.rpc = rpc
        self.navigationController = navigationController
        self.coordinator = AddAddressCoordinator(navigationController: navigationController)
    }

    override func start() -> Signal<CoordinationResult, NoError> {
        return coordinator.start()
            .flatMapLatest { result -> SafeSignal<CoordinationResult> in
                guard case .address(let address) = result else {
                    return Signal.just(CoordinationResult.cancel)
                }
                return self.rpc.tokenInfo(for: address)
                    .map { CoordinationResult.token($0) }
                    .flatMapError { _ -> SafeSignal<CoordinationResult> in
                        // If the address does not have a TokenInfo attached,
                        // ask the user for this information
                        self.showEnterInfoAlert()
                            .map { result -> CoordinationResult in
                                guard case let .info(name, symbol, decimals) = result else {
                                    return .cancel
                                }
                                let token = Token(address: address,
                                                  name: name,
                                                  symbol: symbol,
                                                  decimals: decimals,
                                                  whitelisted: false)
                                return .token(token)
                        }
                }
        }
    }
}

private enum EnterInfoResult {
    case info(name: String, symbol: String, decimals: Int)
    case cancel
}

private extension AddTokenCoordinator {
    func showEnterInfoAlert() -> SafeSignal<EnterInfoResult> {
        let subject = SafePublishSubject<EnterInfoResult>()

        let alert = UIAlertController(title: "TokenList.EnterInfo.Alert.Title".localized,
                                      message: "TokenList.EnterInfo.Alert.Message".localized,
                                      preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "TokenList.EnterInfo.Alert.SymbolTextfield.Placeholder".localized
        }
        alert.addTextField { textField in
            textField.placeholder = "TokenList.EnterInfo.Alert.NameTextfield.Placeholder".localized
        }
        alert.addTextField { textField in
            textField.placeholder = "TokenList.EnterInfo.Alert.DecimalsTextfield.Placeholder".localized
            textField.keyboardType = .numberPad
        }

        let addAction = UIAlertAction(
            title: "TokenList.EnterInfo.Alert.ConfirmButton.Title".localized,
            style: .default) { _ in
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
        let cancelAction = UIAlertAction(
            title: "Shared.ButtonTitle.Cancel".localized,
            style: .cancel) { _ in
                subject.completed(with: .cancel)
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true)
        return subject.toSignal()
    }
}
