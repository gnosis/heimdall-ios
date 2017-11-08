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

            class MockProvider: JsonRpcProvider {
                let mockReturnUInt = BigUInt(123_456)
                let mockReturnHash = Hash(hexString: "0x7238f257c2652c72e17fee12e6ee22d15d1ae87540e74dd73c318183e8f37739")

                var actualTransaction: Transaction?
                var actualSignedTransaction: Data?

                override var chainId: ChainId {
                    return .ChainIdKovan
                }

                override func call(_ transaction: Transaction) -> DataPromise {
                    actualTransaction = transaction

                    let data = Data(fromHexEncodedString: (try! Solidity.UInt256(mockReturnUInt)).encode())!
                    let promise = DataPromise.resolved(data as NSData)!
                    return promise
                }

                override func sendTransaction(_ signedTransaction: Data) -> HashPromise {
                    actualSignedTransaction = signedTransaction

                    return HashPromise.resolved(mockReturnHash)
                }
            }

            it("should call function & decode results correctly") {
                let credentials = try! Credentials(from: "legal winner thank year wave sausage worth useful legal winner thank yellow")
                let fromAddress = Address(string: credentials.address)
                let contractAddress = "0x72E7780A3B3927d5784843ce1e58c1593bBaaF49"
                let balanceAddress = try! Solidity.Address("0")
                let functionCallData = StandardToken.BalanceOf.encodeCall(arguments: balanceAddress).withoutHexPrefix

                let provider = MockProvider()
                let nonceProvider = MockNonceProvider()

                let rpc = EtherRPC(provider: provider, credentials: credentials, nonceProvider: nonceProvider)

                waitUntil { done in
                    _ = rpc.call(StandardToken.BalanceOf.self,
                                 ofContractAt: contractAddress,
                                 with: balanceAddress)
                        .observeNext { returnUInt in
                            expect(returnUInt.value) == provider.mockReturnUInt
                            expect(provider.actualTransaction).toNot(beNil())
                            expect(provider.actualTransaction?.fromAddress) == fromAddress
                            expect(provider.actualTransaction?.chainId) == provider.chainId
                            expect(provider.actualTransaction?.nonce) == nonceProvider.nextNonce()
                            expect(provider.actualTransaction?.toAddress) == Address(string: contractAddress)
                            expect(provider.actualTransaction?.data) == Data(fromHexEncodedString: functionCallData)!

                            done()
                    }
                }
            }

            it("should sign & broadcast transactions correctly") {
                let credentials = try! Credentials(from: "legal winner thank year wave sausage worth useful legal winner thank yellow")
                let fromAddress = Address(string: credentials.address)
                let contractAddress = "0x72E7780A3B3927d5784843ce1e58c1593bBaaF49"
                let balanceAddress = try! Solidity.Address("0")
                let functionCallData = StandardToken.BalanceOf.encodeCall(arguments: balanceAddress).withoutHexPrefix

                let provider = MockProvider()
                let nonceProvider = MockNonceProvider()

                let rpc = EtherRPC(provider: provider, credentials: credentials, nonceProvider: nonceProvider)

                waitUntil { done in
                    _ = rpc.sendTransaction(for: StandardToken.BalanceOf.self,
                                            ofContractAt: contractAddress,
                                            with: balanceAddress)
                        .observeNext { hash in
                            expect(hash) == provider.mockReturnHash
                            let actualTransaction = Transaction(data: provider.actualSignedTransaction!)
                            expect(actualTransaction).toNot(beNil())
                            expect(actualTransaction.fromAddress) == fromAddress
                            expect(actualTransaction.chainId) == provider.chainId
                            expect(actualTransaction.nonce) == nonceProvider.nextNonce()
                            expect(actualTransaction.toAddress) == Address(string: contractAddress)
                            expect(actualTransaction.data) == Data(fromHexEncodedString: functionCallData)!

                            done()
                    }
                }
            }
        }
    }
}
