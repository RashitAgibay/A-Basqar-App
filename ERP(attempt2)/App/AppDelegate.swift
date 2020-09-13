//
//  AppDelegate.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 10/25/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Printer


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public let bluetoothPrinterManager = BluetoothPrinterManager()    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        window = UIWindow()
        AppSetup.shared.setupRootViewController(window: window!)
        
        return true
    }

    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

