//
//  EtherAmountSpec.swift
//  HeimdallTests
//
//  Created by Luis Reisewitz on 17.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt
@testable import Heimdall
import Nimble
import Quick

class EtherAmountSpec: QuickSpec {
    override func spec() {
        describe("EtherAmount") {
            it("should correctly convert between Wei & Ether") {
                let amount = EtherAmount(ether: BigInt(1))
                expect(amount.rawWei) == BigInt(1_000_000_000_000_000_000)
                expect(amount.rawEther) == 1

                let amount2 = EtherAmount(ether: 1.5)
                expect(amount2.rawWei) == BigInt(1_500_000_000_000_000_000)
                expect(amount2.rawEther) == 1.5

                let amount3 = EtherAmount(wei: BigInt(1_000_000_000_000_000))
                expect(amount3.rawWei) == BigInt(1_000_000_000_000_000)
                expect(amount3.rawEther) == 0.001

                let amount4 = EtherAmount(wei: BigInt("1000000000000000000000")!)
                expect(amount4.rawWei) == BigInt("1000000000000000000000")!
                expect(amount4.rawEther) == 1_000
            }

            it("should correctly choose the right denomination for the description") {
                let amount = EtherAmount(ether: BigInt(1))
                expect(amount.descriptionAsEther) == "1.0000 Ξ"
                expect(amount.descriptionAsWei) == "1000000000000000000 Wei"
                expect(amount.description) == "1.0000 Ξ"

                let amount2 = EtherAmount(ether: 1.5)
                expect(amount2.descriptionAsEther) == "1.5000 Ξ"
                expect(amount2.descriptionAsWei) == "1500000000000000000 Wei"
                expect(amount2.description) == "1.5000 Ξ"

                let amount3 = EtherAmount(wei: BigInt(1_000_000_000_000_000))
                expect(amount3.descriptionAsEther) == "0.0010 Ξ"
                expect(amount3.descriptionAsWei) == "1000000000000000 Wei"
                expect(amount3.description) == "0.0010 Ξ"

                let amount4 = EtherAmount(wei: BigInt("1000000000000000000000")!)
                expect(amount4.descriptionAsEther) == "1000.0000 Ξ"
                expect(amount4.descriptionAsWei) == "1000000000000000000000 Wei"
                expect(amount4.description) == "1000.0000 Ξ"
            }
        }
    }
}
