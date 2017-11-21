//
//  SafeListViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Bond
import ReactiveKit

class SafeListViewModel {
    private let disposeBag = DisposeBag()

    // Inputs of VC
    let items = Property<[SafeListCellViewModel]>([])
    let title = Property("Safe.ViewController.Title".localized)

    // Outputs of VC
    let addSafeAction = SafePublishSubject<Void>()
    let deleteSafeAction = SafePublishSubject<IndexPath>()
    let openIndexAction = SafePublishSubject<IndexPath>()

    // Inputs of Coord
    let openSafeAction = SafePublishSubject<Safe>()

    init(store: AppDataStore<Safe>) {
        store.contents
            .flatMap { SafeListCellViewModel(safe: $0) }
            .bind(to: items)
            .dispose(in: disposeBag)
        // Handle cell deletions
        deleteSafeAction
            .with(latestFrom: items)
            .observeNext { indexPath, safes in
                let safe = safes[indexPath.row].safe
                do {
                    try store.remove(safe)
                } catch {
                    print(error)
                }
            }
            .dispose(in: disposeBag)
        // Handle cell selection
        openIndexAction
            .with(latestFrom: items)
            .map { indexPath, safes in
                safes[indexPath.row].safe
            }
            .bind(to: openSafeAction)
            .dispose(in: disposeBag)
    }
}
