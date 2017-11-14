//
//  EtherAmount.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 05.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt

private let etherToWeiFactor = BigInt(1_000_000_000_000_000_000)
private let minimumEtherDisplayThreshold = BigInt(0.000_1)
private let weiSymbol = "Wei"
private let etherSymbol = "Ξ"

struct EtherAmount {
    let wei: BigInt

    init(wei: BigInt) {
        self.wei = wei
    }

    init(ether: BigInt) {
        wei = ether * etherToWeiFactor
    }
}

// MARK: - Raw Amounts
extension EtherAmount {
    var rawWei: BigInt {
        return wei
    }

    var rawEther: BigInt {
        return wei / etherToWeiFactor
    }
}

// MARK: - String Descriptions
extension EtherAmount {
    var descriptionAsWei: String {
        return "\(rawWei) \(weiSymbol)"
    }

    var descriptionAsEther: String {
        return "\(rawEther) \(etherSymbol)"
    }

    var description: String {
        // TODO: This is not localized. Should it be?
        guard rawEther >= minimumEtherDisplayThreshold else {
            return descriptionAsWei
        }
        return descriptionAsEther
    }
}

// MARK: - BigInt to EtherAmount
extension BigInt {
    var wei: EtherAmount {
        return EtherAmount(wei: self)
    }

    var ether: EtherAmount {
        return EtherAmount(ether: self)
    }
}
