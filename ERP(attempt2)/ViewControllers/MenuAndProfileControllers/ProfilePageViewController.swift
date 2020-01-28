//
//  ProfilePageViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/1/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var editDataButton: UIButton!
    @IBOutlet weak var editPasswordButton: UIButton!
    
    var userTokenForUserStandart: String = "userToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        editDataButton.layer.cornerRadius = 20
        editDataButton.dropShadowforButton()
        
        editPasswordButton.layer.cornerRadius = 20
        editPasswordButton.dropShadowforButton()
        
        
    }
    

    @IBAction func tappedLogoutButton(_ sender: Any) {
        
        ShowErrorsAlertWithTwoButton(title: "Выйти", message: "Вы хотите выйти из аккаунта?", buttomMessage: "Выйти")
        
    }
    
    func ShowErrorsAlertWithTwoButton(title: String, message: String, buttomMessage: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttomMessage, style: .default) { (action) in
            UserDefaults.standard.set(nil, forKey: self.userTokenForUserStandart)
            self.performSegue(withIdentifier: "logoutbuttontapped", sender: self)
        }
        let secondAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        }
        alertController.addAction(secondAction)
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }

}
