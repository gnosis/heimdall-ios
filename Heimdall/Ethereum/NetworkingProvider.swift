//
//  NetworkingProvider.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 30.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ethers

protocol NetworkingProvider {
    var chainId: ChainId { get }
    var rpcProvider: JsonRpcProvider { get }
    var nonceProvider: NonceProvider { get }
}

struct NetworkingProviderImpl: NetworkingProvider {
    let chainId: ChainId
    let rpcProvider: JsonRpcProvider
    let nonceProvider: NonceProvider

    init() {
        chainId = .ChainIdHomestead
        rpcProvider = InfuraProvider(chainId: chainId,
                                     accessToken: Secrets.infuraKey.rawValue)
        nonceProvider = NonceProvider()
        // TODO: Infura Key is dependent on chainId, make this clear somehow
    }
}
