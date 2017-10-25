//
//  HeimdallTests.swift
//  HeimdallTests
//
//  Created by Luis Reisewitz on 18.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

@testable import Heimdall
import Nimble
import Quick

class HeimdallSpec: QuickSpec {
    override func spec() {
        describe("Heimdall") {
            it("should be able to run Quick test") {
                expect(3).toNot(be(5))
            }
        }
    }
}
