//
//  CredentialsSpec.swift
//  HeimdallTests
//
//  Created by Luis Reisewitz on 30.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

@testable import Heimdall
import Nimble
import Quick

private let testMnemonicPhrase = "legal winner thank year wave sausage worth useful legal winner thank yellow"
private let testPrivateKey = "0x33fa40f84e854b941c2b0436dd4a256e1df1cb41b9c1c0ccc8446408c19b8bf9"
private let testAddress = "0x58A57ed9d8d624cBD12e2C467D34787555bB1b25"

class CredentialsSpec: QuickSpec {
    override func spec() {
        describe("Credentials") {
            it("should generate correct private key") {
                let credentials = try! Credentials(from: testMnemonicPhrase)
                expect(credentials.privateKey) == testPrivateKey
            }

            it("should generate correct address") {
                let credentials = try! Credentials(from: testMnemonicPhrase)
                expect(credentials.address) == testAddress
            }

            it("should generate private key data") {
                let credentials = try! Credentials(from: testMnemonicPhrase)
                let data = Data(fromHexEncodedString: testPrivateKey.withoutHexPrefix)!
                expect(credentials.privateKeyData) == data
            }
        }
    }
}
