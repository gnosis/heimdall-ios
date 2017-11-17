//
//  EtherAmount.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 05.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt

private let etherToWeiFactor = BigInt(1_000_000_000_000_000_000)
private let minimumEtherDisplayThreshold = 0.000_1
private let weiSymbol = "Wei"
private let etherSymbol = "Ξ"

struct EtherAmount {
    enum Error: String, Swift.Error {
        case doubleConversionFailed = "Could not represent Wei amount as a Double."
    }

    let wei: BigInt

    init(wei: BigInt) {
        self.wei = wei
    }

    init(ether: BigInt) {
        self.init(wei: ether * etherToWeiFactor)
    }

    init(ether: Double) {
        guard let etherToWeiFactoryDouble = Double(etherToWeiFactor.description) else {
            die(Error.doubleConversionFailed)
        }
        let weiDouble = ether * etherToWeiFactoryDouble
        let wei = BigInt(weiDouble)
        self.init(wei: wei)
    }
}

// MARK: - Raw Amounts
extension EtherAmount {
    var rawWei: BigInt {
        return wei
    }

    /// Converts the internal amount of Wei to the amount of Ether by trying to
    /// represent them as a Double. If the amount of Wei is too big to be represented
    /// as a Double, this method `die`s with the error `EtherAmount.Error.weiAmountTooBigForDouble`.
    /// - Warning:
    ///     The current max amount of Wei (90 million Ether * 10**18) fits into a Double.
    ///     Still, this could lead to precision errors. For exact calculations and
    /// 	sending Ether only ever use the `rawWei` value.
    var rawEther: Double {
        guard let weiDouble = Double(wei.description),
            let etherToWeiFactorDouble = Double(etherToWeiFactor.description) else {
                die(Error.doubleConversionFailed)
        }
        return weiDouble / etherToWeiFactorDouble
    }
}

// MARK: - String Descriptions
extension EtherAmount {
    var descriptionAsWei: String {
        return "\(rawWei) \(weiSymbol)"
    }

    var descriptionAsEther: String {
        return "\(String(format: "%.4f", rawEther)) \(etherSymbol)"
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
