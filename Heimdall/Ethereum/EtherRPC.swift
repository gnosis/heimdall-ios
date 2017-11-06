//
//  EtherRPC.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 05.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import BigInt
import ethers
import ReactiveKit

class EtherRPC {
    enum Error: Swift.Error {
        case invalidCallData
        case invalidCredentials
        case invalidReturnData
        case transactionFailed
    }

    private let provider: JsonRpcProvider
    private let credentials: Credentials
    private let nonceProvider: NonceProvider

    init(provider: JsonRpcProvider,
         credentials: Credentials,
         nonceProvider: NonceProvider) {
        self.provider = provider
        self.credentials = credentials
        self.nonceProvider = nonceProvider
    }
}

// MARK: - Reactive Contract Calling
extension EtherRPC {
    func call<Function: SolidityFunction>(_ function: Function.Type,
                                          ofContractAt address: String,
                                          with arguments: Function.Arguments) -> Signal<Function.Return, Error> {
        return Signal { observer in
            self.call(function,
                      ofContractAt: address,
                      with: arguments,
                      success: { value in
                        observer.completed(with: value)
            },
                      failure: { error in
                        observer.failed(error)
            })
            return NonDisposable.instance
        }
    }

    func sendTransaction<Function: SolidityFunction>(for function: Function.Type,
                                                     ofContractAt address: String,
                                                     with arguments: Function.Arguments) -> Signal<Hash, Error> {
        return Signal { observer in
            self.sendTransaction(for: function,
                                 ofContractAt: address,
                                 with: arguments,
                                 success: { hash in
                                    observer.completed(with: hash)
            },
                                 failure: { error in
                                    observer.failed(error)
            })
            return NonDisposable.instance
        }
    }

    func balance(for address: String) -> Signal<EtherAmount, Error> {
        return Signal { observer in
            self.balance(for: address,
                         success: {
                            observer.completed(with: $0.wei)
            },
                         failure: {
                            observer.failed($0)
            })
            return NonDisposable.instance
        }
    }
}

// MARK: - Private Contract Calling
private extension EtherRPC {
    func call<Function: SolidityFunction>(_ function: Function.Type,
                                          ofContractAt address: String,
                                          with arguments: Function.Arguments,
                                          success: @escaping (Function.Return) -> Void,
                                          failure: @escaping (Error) -> Void) {

        do {
            let transaction = try signedTransaction(for: function,
                                                    ofContractAt: address,
                                                    with: arguments)
            provider.call(transaction)
            .onCompletion { promise in
                guard let data = promise?.value else {
                    failure(.invalidReturnData)
                    return
                }
                let returnString = data.hexEncodedString()
                guard let returnValue = try? Function.decode(returnData: returnString) else {
                    failure(.invalidReturnData)
                    return
                }
                success(returnValue)
            }
        } catch let error as EtherRPC.Error {
            async {
                // Call this async as to not release Z̕A̶LG͏O
                // http://blog.izs.me/post/59142742143/designing-apis-for-asynchrony
                failure(error)
            }
        } catch {
            die("Received an unknown error: \(error)")
        }
    }

    func sendTransaction<Function: SolidityFunction>(for function: Function.Type,
                                                     ofContractAt address: String,
                                                     with arguments: Function.Arguments,
                                                     success: @escaping (Hash) -> Void,
                                                     failure: @escaping (Error) -> Void) {
        // TODO: Complete process (not currently possible)
        // 1. perform transaction
        // 2. get hash
        // 3. use hash to get receipt
        // 4. then get the logs out of receipt
        do {
            let transaction = try signedTransaction(for: function,
                                                    ofContractAt: address,
                                                    with: arguments)
            provider.sendTransaction(transaction.serialize())
            .onCompletion { promise in
                guard let hash = promise?.value else {
                    failure(.transactionFailed)
                    return
                }
                success(hash)
            }
        } catch let error as EtherRPC.Error {
            async {
                // Dispatch failure handler async so as to not release Hę w͘ho͟ W͡áít̛s ̨B̛ȩhi̢n̶d́ T̴he ́Wal͞l͘.
                failure(error)
            }
        } catch {
            die("Received an unknown error: \(error)")
        }
    }

    func signedTransaction<Function: SolidityFunction>(for function: Function.Type,
                                                       ofContractAt address: String,
                                                       with arguments: Function.Arguments) throws -> Transaction {
        let callString = function.encodeCall(arguments: arguments)
        // Drop leading 0x in function call
        let callWithoutLeadingZeroX = String(callString.withoutHexPrefix)

        guard let callData = Data(fromHexEncodedString: callWithoutLeadingZeroX) else {
             throw Error.invalidCallData
        }
        guard let account = credentials.account else {
            throw Error.invalidCredentials
        }

        let transaction = Transaction(from: Address(string: credentials.address))
        transaction.toAddress = Address(string: address)
        transaction.data = callData
        transaction.nonce = nonceProvider.nextNonce()
        // Use ChainId from injected and initialised provider
        transaction.chainId = provider.chainId

        account.sign(transaction)

        return transaction
    }

    func balance(for address: String,
                 success: @escaping (BigInt) -> Void,
                 failure: @escaping (Error) -> Void) {
        provider.getBalance(Address(string: address))
            .onCompletion { promise in
                guard let balance = promise?.value,
                    let returnValue = BigInt(balance.hexString.withoutHexPrefix, radix: 16) else {
                        failure(.invalidReturnData)
                        return
                }
                // balance is a bigint, unit is Wei
                success(returnValue)
        }
    }
}
