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
    let title = Property<String?>("Shared.Title.Share".localized)

    // MARK: Custom Stuff
    let closeShareAction = SafePublishSubject<Void>()
    let qrCodeImage = Property<UIImage?>(nil)

    init(payload: String) {
        let squareSideLength = 200
        let imageSize = CGSize(width: squareSideLength, height: squareSideLength)
        qrCodeImage.value = try? QRCodeGenerator.image(for: payload, size: imageSize)
    }
}
