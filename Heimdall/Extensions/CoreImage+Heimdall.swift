//
//  CoreImage+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 22.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import CoreImage

extension CIFilter {
    static var qrCodeInputCorrectionLevelKey: String {
        return "inputCorrectionLevel"
    }
    static var qrCodeInputMessageKey: String {
        return "inputMessage"
    }

    static var qrCodeGenerator: CIFilter? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        filter.setValue("Q", forKey: qrCodeInputCorrectionLevelKey)
        return filter
    }
}
