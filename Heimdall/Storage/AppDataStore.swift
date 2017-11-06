//
//  AppDataStore.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 02.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit

protocol Storable: Codable, Equatable {
    static var storageKey: String { get }
}

class AppDataStore<Element: Storable> {
    private let store: DataStore

    let contents = Property<[Element]>([])

    static var storageKey: String {
        return "\(Element.storageKey)_List"
    }

    /// Creates a new app data store by using the given store as a storage backend.
    ///
    /// - Parameter store: Underlying storage to use for the credentials.
    init(store: DataStore) {
        self.store = store
    }

    func add(_ element: Element) throws {
        var elements: [Element] = (try? fetchAll()) ?? []
        elements.append(element)
        try store.store(elements, for: type(of: self).storageKey)
        contents.value = elements
    }

    func fetchAll() throws -> [Element] {
        return try store.fetch(key: type(of: self).storageKey)
    }

    func remove(_ element: Element) throws {
        guard var elements: [Element] = try? fetchAll(),
            let index = elements.index(of: element) else { return }
        elements.remove(at: index)
        try store.store(elements, for: type(of: self).storageKey)
        contents.value = elements
    }
}
