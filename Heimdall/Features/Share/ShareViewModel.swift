//
//  ShareViewModel.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 27.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class ShareViewModel: SeparatedViewModel {
    // MARK: SeparatedViewModel
    typealias View = ShareView
    let title: Property<String?>

    // MARK: Custom Stuff
    let closeShareAction = SafePublishSubject<Void>()
    let shareAction = SafePublishSubject<Void>()
    let qrCodeImage = Property<UIImage?>(nil)
    let shareButtonTitle = Property("Shared.Title.Share".localized)
    let payloadLabelText: Property<String>

    init(shareable: Shareable) {
        let squareSideLength = 200
        let imageSize = CGSize(width: squareSideLength, height: squareSideLength)
        qrCodeImage.value = try? QRCodeGenerator.image(for: shareable.payload, size: imageSize)
        payloadLabelText = Property(shareable.payload)
        title = Property(shareable.title)
    }
}
