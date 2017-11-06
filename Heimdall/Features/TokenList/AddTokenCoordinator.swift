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



    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() -> Signal<CoordinationResult, NoError> {
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

        let subject = SafePublishSubject<CoordinationResult>()
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let textFields = alert.textFields,
                textFields.count == 3,
                let symbol = textFields[0].text,
                let name = textFields[1].text,
                let decimalsString = textFields[2].text,
                let decimals = Int(decimalsString) else {
                    return
            }
            let token = Token(name: name, symbol: symbol, decimals: decimals)
            subject.completed(with: .token(token))
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            subject.completed(with: .cancel)
        })

        navigationController.present(alert, animated: true)
        return subject.toSignal()
    }
}
