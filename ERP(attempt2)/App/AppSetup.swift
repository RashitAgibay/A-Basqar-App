//
//  AppSetup.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 9/12/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import Foundation

class AppSetup {
    
    public static let shared = AppSetup()
    
    func setupRootViewController(window: UIWindow) {
        
        let token = UserDefaults.standard.string(forKey: "new_userTokenKey")
        
        if token == nil {
            
            setupUnAuthorizedUser(window: window)
        }
        
        else {
            
            setupAuthorizedUser(window: window)
        }
        
    }
    
    // Setup Main Screen
    private func setupAuthorizedUser(window: UIWindow) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "menuStoryboadrid") as! MenuViewController
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    // Setup Login Screen
    private func setupUnAuthorizedUser(window: UIWindow) {
        
        let mainStoryBoard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
