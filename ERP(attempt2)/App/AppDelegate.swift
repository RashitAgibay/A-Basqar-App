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
//    public let dummyPrinter = DummyPrinter()
    
    // MARK: - Приложение ios 13 тен төмен версияларында ашылу үшін
    var window: UIWindow?
    var userTokenForUserStandart: String = "new_userTokenKey"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //MARK: клавиатураны реттейтін библеотека
        IQKeyboardManager.shared.enable = true
        
        
        //MARK: - Осының арқасында логин жасаған болсам сразу меню бетіне өтіп кетем
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart)
        
        if token == nil {
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier:  "LoginPage") as! SignInViewController
            self.window?.rootViewController = homePage
        }
        
        if token != nil {
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier:  "menuStoryboadrid") as! MenuViewController
            self.window?.rootViewController = homePage
        }
        
        
        
        
        return true
    }

    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

