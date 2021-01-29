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
        let profileNetworkManager = ProfileNetworManager()
        
        profileNetworkManager.getProfileInfo { (userProfileData, error) in
            print("/// userProfileData", userProfileData)
            print("/// error", error)
            
            self.fullnameLabel.text = userProfileData?.fullname
            self.businessNameLabel.text = userProfileData?.store.company.name

        }
    }
    
//    private func getProfileInfo() {
//        do {
//            self.reachability = try Reachability.init()
//        }
//
//        catch {
//            print("unable to start notifier")
//        }
//
//        if ((reachability?.connection) != .unavailable) {
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//
//            let token = UserDefaults.standard.string(forKey: userTokenKey) ?? ""
//            let headers: HTTPHeaders = [
//
//                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
//                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
//            ]
//
//            let encodeURL = profileURL
//            let requestOfApi = AF.request(encodeURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
//
//            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
//                MBProgressHUD.hide(for: self.view, animated: true)
////                    print(response.request!)
////                    print(response.result)
////                    print(response.response!)
//
//                switch response.result {
//                case .success(let payload):
//                    MBProgressHUD.hide(for: self.view, animated: true)
//
//                    print("/// payload", payload)
//                    if let x = payload as? Dictionary<String,AnyObject> {
//                        print("dict", x)
//                    }
//                    else {
//                        let data = payload as! NSArray
//                        let currentData = data.firstObject as! NSDictionary
//                        let companyData = currentData["company"] as! NSDictionary
//
//                        self.profileImageView.sd_setImage(with: URL(string: currentData["avatar"] as! String), placeholderImage: UIImage(named: "porfile_page_default_icon_user"))
//
//                        self.fullnameLabel.text = currentData["full_name"] as! String
//
//
//                    }
//                case .failure(let error):
//                    print(error)
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    self.showErrorsAlertWithOneCancelButton(message: "\(error)")
//                }
//            })
//        }
//        else {
//            print("internet is not working")
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
//        }
//    }
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
