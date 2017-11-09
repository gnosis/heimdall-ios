//
//  VerifiedTokenProvider.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 08.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ethers

struct VerifiedTokenProvider {
    let chainId: ChainId
    let verifiedTokens: [Token]

    init(chainId: ChainId) {
        self.chainId = chainId

        let filename = tokenListFilename(for: chainId)
        self.verifiedTokens = tokens(from: filename)
    }
}

private func tokenListFilename(for chain: ChainId) -> String {
    switch chain {
    case .ChainIdHomestead:
        return "mainnet"
    case .ChainIdKovan:
        return "kovan"
    default:
        fatalError("Unsupported chain.")
    }
}

private func tokens(from filename: String) -> [Token] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let jsonAny = try? JSONSerialization.jsonObject(with: data, options: []),
        let jsonArray = jsonAny as? [[String: Any]] else {
        return []
    }
    return jsonArray.flatMap { Token(from: $0) }
}

private extension Token {
    init?(from whitelistedJson: [String: Any]) {
        guard let address = whitelistedJson["address"] as? String,
            let name = whitelistedJson["name"] as? String,
            let symbol = whitelistedJson["symbol"] as? String,
            let decimals = whitelistedJson["decimals"] as? Int else {
                return nil
        }
        self.init(address: address, name: name, symbol: symbol, decimals: decimals, whitelisted: true)
    }
}
