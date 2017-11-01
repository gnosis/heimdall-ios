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
        case couldNotCreateProvider
        case invalidCallData
        case invalidCredentials
        case invalidReturnData
    }

    private let provider: JsonRpcProvider
    private let credentials: Credentials
    private let nonceProvider: NonceProvider
    private let chainProvider: ChainProvider

    init(provider: JsonRpcProvider,
         credentials: Credentials,
         nonceProvider: NonceProvider,
         chainProvider: ChainProvider) {
        self.provider = provider
        self.credentials = credentials
        self.nonceProvider = nonceProvider
        self.chainProvider = chainProvider
    }
}

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
}

private extension EtherRPC {
    func call<Function: SolidityFunction>(_ function: Function.Type,
                                          ofContractAt address: String,
                                          with arguments: Function.Arguments,
                                          success: @escaping (Function.Return) -> Void,
                                          failure: @escaping (Error) -> Void) {
        let callString = function.encodeCall(arguments: arguments)
        // Drop leading 0x in function call
        let callWithoutLeadingZeroX = String(callString.dropFirst(2))
        guard let callData = Data(fromHexEncodedString: callWithoutLeadingZeroX) else {
            DispatchQueue.main.async {
                // Call this async as to not release Z̕A̶LG͏O
                failure(.invalidCallData)
            }
            return
        }
        guard let account = Account(privateKey: credentials.privateKeyData) else {
            DispatchQueue.main.async {
                // Call this async as to not release Th͏e Da҉rk Pońy Lo͘r͠d HE ́C͡OM̴E̸S
                failure(.invalidCredentials)
            }
            return
        }

        let transaction = Transaction(from: Address(string: credentials.address))
        transaction.toAddress = Address(string: address)
        transaction.data = callData
        transaction.nonce = nonceProvider.nextNonce()
        // Use ChainId from injected and initialised provider
        transaction.chainId = provider.chainId

        account.sign(transaction)
        provider.call(transaction).onCompletion { promise in
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
    }
}
