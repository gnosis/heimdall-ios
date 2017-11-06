//
//  ReactiveUITableViewCell.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import UIKit
import ReactiveKit

class ReactiveUITableViewCell: UITableViewCell {
    let reuseBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        reuseBag.dispose()
    }
}
