//
//  String+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 14.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

extension String {
    enum Error: String, Swift.Error {
        case localizationNotFound
    }

    var localized: String {
        return localized()
    }

    func localized(comment: String = "", _ args: CVarArg...) -> String {
        let localizedString = String(format: NSLocalizedString(self, comment: comment), arguments: args)

        // Check if the localized string is just the localization key (which
        // means there is no localization for that key). If that happens, we
        // just crash to detect that stuff early on.
        let formattedKey = String(format: self, arguments: args)
        guard localizedString != formattedKey else {
            die(Error.localizationNotFound)
        }
        return localizedString
    }
}
