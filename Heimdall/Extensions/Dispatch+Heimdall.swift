//
//  Dispatch+Heimdall.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 01.11.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static var background = DispatchQueue(label: "Heimdall.global.background", qos: .background)
}

/// Dispatches a function to be executed async on the specified DispatchQueue.
///
/// - Parameters:
///   - queue: DispatchQueue on which the closure should be dispatched on.
///     Defaults to `DispatchQueue.background`.
///   - closure: Function to execute asynchronously.
func async(queue: DispatchQueue = .background, closure: @escaping () -> Void) {
    queue.async(execute: closure)
}
