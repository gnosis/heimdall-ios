//
//  BigInt+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt
extension BigUInt {
    var forcedUInt: UInt {
        guard let uint = UInt(description) else {
            die("BigUInt.forcedUInt does not fit into a regular UInt.")
        }
        return uint
    }
    var forcedInt: Int {
        guard let int = Int(description) else {
            die("BigUInt.forcedInt does not fit into a regular Int.")
        }
        return int
    }
}

extension BigInt {
    var forcedInt: Int {
        guard let int = Int(description) else {
            die("BigInt.forcedInt does not fit into a regular Int.")
        }
        return int
    }
}
