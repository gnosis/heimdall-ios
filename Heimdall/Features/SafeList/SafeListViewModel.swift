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

    let items = Property<[SafeListCellViewModel]>([])
    let title = Property("Safes")

    var addSafe = SafePublishSubject<Void>()
    var deleteSafe = SafePublishSubject<IndexPath>()

    init(store: AppDataStore<Safe>) {
        store.contents
            .flatMap { SafeListCellViewModel(safe: $0) }
            .bind(to: items)
            .dispose(in: disposeBag)
        // Handle cell deletions
        deleteSafe
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
    }
}
