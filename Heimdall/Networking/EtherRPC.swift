//
//  EtherRPC.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 05.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation
import ethers
import BigInt
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

    func call<Function: SolidityFunction>(_ function: Function.Type, at address: String, with arguments: Function.Arguments) -> Signal<Function.Return, Error> {
        let provider = self.provider
        let credentials = self.credentials
        let nonceProvider = self.nonceProvider

        return Signal { observer in
            let callString = function.encodeCall(arguments: arguments)
            // Drop leading 0x in function call
            let callWithoutLeadingZeroX = String(callString.dropFirst(2))
            guard let callData = Data(fromHexEncodedString: callWithoutLeadingZeroX) else {
                observer.failed(.invalidCallData)
                return NonDisposable.instance
            }
            guard let account = Account(privateKey: credentials.privateKeyData) else {
                observer.failed(.invalidCredentials)
                return NonDisposable.instance
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
                    observer.failed(.invalidReturnData)
                    return
                }
                let returnString = data.hexEncodedString()
                guard let returnValue = try? Function.decode(returnData: returnString) else {
                    observer.failed(.invalidReturnData)
                    return
                }
                observer.next(returnValue)
                observer.completed()
            }

            return NonDisposable.instance
        }

    }
}
