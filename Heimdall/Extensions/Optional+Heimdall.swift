//
//  Optional+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 13.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
        case let .some(value):
            return value.isEmpty
        default:
            return true
        }
    }
}
