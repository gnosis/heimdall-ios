//
//  QRCodeGenerator.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 27.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import CoreImage
import UIKit

struct QRCodeGenerator {
    enum Error: Swift.Error {
        case qrFilterNotAvailable
        case couldNotGenerateImage
        case payloadNotUtf8
    }

    static func image(for data: Data, size: CGSize) throws -> UIImage {
        guard let filter = CIFilter.qrCodeGenerator else {
            throw Error.qrFilterNotAvailable
        }
        filter.setValue(data, forKey: CIFilter.qrCodeInputMessageKey)
        guard let ciImage = filter.outputImage else {
            throw Error.couldNotGenerateImage
        }

        let scaleX = size.width / ciImage.extent.size.width
        let scaleY = size.height / ciImage.extent.size.height

        let transformedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        return UIImage(ciImage: transformedImage)
    }

    // TODO: These might need to be put on a background queue
    static func image(for payload: String, size: CGSize) throws -> UIImage {
        guard let data = payload.data(using: .utf8) else {
            throw Error.payloadNotUtf8
        }
        return try image(for: data, size: size)
    }
}
