//
//  Fatal.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 11.09.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import Foundation

func die(_ message: String, line: Int = #line, function: String = #function, file: String = #file) -> Never {
    NSLog("===================================================================")
    NSLog("die() called from \((file as NSString).lastPathComponent): \(function): \(line)")
    NSLog("\tMessage: \(message)")
    fatalError(message)
}
