//
//  AppDelegate.swift
//  Heimdall
//
//  Created by Luis Reisewitz on 18.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

import ReactiveKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let newWindow = UIWindow()
        window = newWindow

        appCoordinator = AppCoordinator(with: newWindow)
        appCoordinator?.start().observeNext {}.dispose(in: disposeBag)

        print("INFURA Test Secret: \(Secrets.infuraKey.rawValue)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
