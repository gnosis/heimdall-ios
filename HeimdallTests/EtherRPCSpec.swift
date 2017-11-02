//
//  EtherRPCSpec.swift
//  HeimdallTests
//
//  Created by Luis Reisewitz on 02.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt
import ethers
@testable import Heimdall
import Nimble
import Quick

class EtherRPCSpec: QuickSpec {
    override func spec() {
        describe("EtherRPC") {
            class MockNonceProvider: NonceProvider {
                override func nextNonce() -> UInt {
                    return 1
                }
            }
            it("should call the rpc provider correctly & decode results") {

                class MockProvider: JsonRpcProvider {
                    let mockReturnValue = BigUInt(123456)
                    var actualTransaction: Transaction?

                    override var chainId: ChainId {
                        return .ChainIdKovan
                    }

                    override func call(_ transaction: Transaction) -> DataPromise {
                        actualTransaction = transaction

                        let data = Data(fromHexEncodedString: (try! Solidity.UInt256(mockReturnValue)).encode())!
                        let promise = DataPromise.resolved(data as NSData)!
                        return promise
                    }
                }

                let credentials = try! Credentials(from: "legal winner thank year wave sausage worth useful legal winner thank yellow")
                let fromAddress = Address(string: credentials.address)
                let contractAddress = "f"
                let balanceAddress = try! Solidity.Address("0")

                let provider = MockProvider()
                let nonceProvider = MockNonceProvider()

                let rpc = EtherRPC(provider: provider, credentials: credentials, nonceProvider: nonceProvider)

                waitUntil { done in
                    rpc.call(StandardToken.BalanceOf.self,
                             ofContractAt: contractAddress,
                             with: balanceAddress)
                        .observeNext { returnUInt in
                            expect(returnUInt.value) == provider.mockReturnValue
                            expect(provider.actualTransaction) != nil
                            expect(provider.actualTransaction?.fromAddress) == fromAddress
                            expect(provider.actualTransaction?.chainId) == provider.chainId
                            expect(provider.actualTransaction?.nonce) == nonceProvider.nextNonce()
                            expect(provider.actualTransaction?.toAddress) == Address(string: contractAddress)

                            done()
                    }
                }
            }
        }
    }
}
