//
//  BigInt+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt
extension BigUInt {
    enum Error: String, Swift.Error {
        case forcedUIntTooWide = "BigUInt.forcedUInt does not fit into a regular UInt."
        case forcedIntTooWide = "BigUInt.forcedInt does not fit into a regular Int."
    }

    var forcedUInt: UInt {
        guard let uint = UInt(description) else {
            die(Error.forcedUIntTooWide)
        }
        return uint
    }
    var forcedInt: Int {
        guard let int = Int(description) else {
            die(Error.forcedIntTooWide)
        }
        return int
    }
}

extension BigInt {
    enum Error: String, Swift.Error {
        case forcedIntTooWide = "BigInt.forcedInt does not fit into a regular Int."
    }

    var forcedInt: Int {
        guard let int = Int(description) else {
            die(Error.forcedIntTooWide)
        }
        return int
    }
}
