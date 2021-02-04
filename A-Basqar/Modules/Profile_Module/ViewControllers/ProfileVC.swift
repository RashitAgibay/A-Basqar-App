//
//  ProfileVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 9/13/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class ProfileVC: DefaultVC {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var editDataButton: UIButton!
    @IBOutlet weak var editPasswordButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getProfileInfo()
    }
    


    private func setupUI() {
        
        editDataButton.layer.cornerRadius = 20
        editDataButton.dropShadowforButton()
        
        editPasswordButton.layer.cornerRadius = 20
        editPasswordButton.dropShadowforButton()
    }

    @IBAction func tappedLogoutButton(_ sender: Any) {
        
        showErrorsAlertWithTwoButton(title: "Выйти", message: "Вы хотите выйти из аккаунта?", buttomMessage: "Выйти")
        
    }
}

extension ProfileVC {
    private func getProfileInfo() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let profileNetworkManager = ProfileNetworManager()
        
        profileNetworkManager.getProfileInfo { (userProfileData, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.fullnameLabel.text = userProfileData?.fullname
            self.businessNameLabel.text = userProfileData?.store.company.name
            self.idLabel.text = userProfileData?.status
            self.username.text = userProfileData?.username
            self.userIdLabel.text = "\(userProfileData?.id as! Int)"

        }
    }
}

extension ProfileVC {
    func showErrorsAlertWithTwoButton(title: String, message: String, buttomMessage: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttomMessage, style: .default) { (action) in
            UserDefaults.standard.set(nil, forKey: userTokenKey)
            self.performSegue(withIdentifier: "fromProfileToLogin", sender: self)
        }
        let secondAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        }
        alertController.addAction(secondAction)
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }
}
