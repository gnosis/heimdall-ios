//
//  Safe.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 13.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

struct Safe: Storable {
    let name: String?
    let address: String

    static var storageKey: String {
        return "Safe"
    }
}

// MARK: - Equatable
extension Safe: Equatable {
    static func == (lhs: Safe, rhs: Safe) -> Bool {
        return lhs.address == rhs.address
    }
}
