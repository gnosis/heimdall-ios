//
//  String+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 02.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

extension String {
    /// Returns a new string, removing a '0x' prefix if present.
    var withoutHexPrefix: String {
        return hasPrefix("0x")
            ? String(dropFirst(2))
            : self
    }
}
