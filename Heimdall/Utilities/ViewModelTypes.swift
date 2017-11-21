//
//  ViewModelTypes.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 21.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

protocol ViewControllerViewModel {
    var title: Property<String?> { get }
}

protocol SeparatedViewModel: ViewControllerViewModel {
    associatedtype View: UIView, SeparatedView
}
