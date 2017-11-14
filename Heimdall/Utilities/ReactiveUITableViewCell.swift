//
//  ReactiveUITableViewCell.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 06.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

class ReactiveUITableViewCell: UITableViewCell {
    let reuseBag = DisposeBag()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        dieFromCoder()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reuseBag.dispose()
    }
}
