//
//  Fatal.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 11.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

func die(_ error: Swift.Error, line: Int = #line, function: String = #function, file: String = #file) -> Never {
    NSLog("===================================================================")
    NSLog("die() called from \((file as NSString).lastPathComponent): \(function): \(line)")
    NSLog("\tMessage: \(error)")
    fatalError(error.localizedDescription)
}

private enum Error: String, Swift.Error {
    case initWithCoderNotImplemented = "init(coder:) & storyboards should not be used."
}

/// Helper method that kills the process. Useful for quickly adding those pesky
/// required init(coder:) initialisers that you don't need when you don't use
/// use storyboards.
///
/// - Returns: Nothing, ever.
func dieFromCoder() -> Never {
    die(Error.initWithCoderNotImplemented)
}
