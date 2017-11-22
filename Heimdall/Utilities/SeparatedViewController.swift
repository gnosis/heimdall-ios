//
//  SeparatedViewController.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 13.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

/// Marker protocol to make sure that view classes can be appropriately
/// instantiated.
protocol SeparatedView {
    init()

    var rightBarButtonItem: UIBarButtonItem? { get }
}

/// Our type of view controller. Separated just means that the whole view for
/// this view controller lives in a separate class. See `SeparatedView` &
/// `AutoLayoutView` for this.
class SeparatedViewController<ViewModel: SeparatedViewModel>: UIViewController {
    let customView = ViewModel.View()
    let viewModel: ViewModel
    let disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        dieFromCoder()
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Already set up SeparatedView properties
        viewModel.title.bind(to: reactive.title)
            .dispose(in: disposeBag)
        navigationItem.rightBarButtonItem = customView.rightBarButtonItem

        // Now give control to subclass
        setup()
    }

    override func loadView() {
        view = customView
    }

    /// The place to bind all your properties to your view model.
    /// - Warning: Needs to be overridden by subclasses. Do not call
    /// `SeparatedViewController.setup()`, either directly or through
    /// `super.setup()`
    func setup() {
        die(HeimdallError.abstractMethodNotOverridden)
    }
}
