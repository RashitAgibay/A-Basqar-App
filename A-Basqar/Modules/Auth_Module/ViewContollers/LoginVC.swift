//
//  LoginVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 9/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class LoginVC: DefaultVC {

    let authApiService = AuthNetworkManager()
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var userTokenForUserStandart: String = "new_userTokenKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 10
        cardView.dropShadow()
        
        loginButton.layer.cornerRadius = 20
        loginButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: loginTextField)
        activateDelegateForTextField(oneTextField: passwordTextField)
        
//        freeSpaceOnLeftSideForTextFiedl(someTextField: loginTextField)
//        freeSpaceOnLeftSideForTextFiedl(someTextField: passwordTextField)
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        if loginTextField.text == "" || passwordTextField.text == "" {
            
            showErrorsAlertWithOneCancelButton(title: "Ошибка", message: "Заполните все поля", buttomMessage: "Закрыть")
        }
        
        else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            var userInfo = UserInfo(username: loginTextField.text ?? "", password: passwordTextField.text ?? "")
            authApiService.login(userInfo: userInfo) { (tokenData, error) in
                MBProgressHUD.hide(for: self.view, animated: true)

                if tokenData?.not_exist == nil {
                    let token = tokenData?.token as! String
                    UserDefaults.standard.set(token, forKey: self.userTokenForUserStandart)
                    self.navigateToMain()
                }
                else {
                    self.showErrorsAlertWithOneCancelButton(message: "Вы ввели логин или пароль не правильно!!!")
                }
            }
        }
    }
}

extension LoginVC {
    
//    func loginApi() {
//
//        do {
//
//            reachability = try Reachability.init()
//        }
//
//        catch {
//
//            print("unable to start notifier")
//        }
//
//        if ((reachability!.connection) != .none) {
//
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//
//            let params = [
//                    "username":self.loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
//                    "password":self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
//            ]
//
//            let headers: HTTPHeaders = [
//                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
//            ]
//
//            let encodeURL = "http://127.0.0.1:8000/api/account/login"
//
//            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
//
//            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
//
//                //print(response.request!)
//                //print(response.result)
//                //print(response.response)
//
//                switch response.result {
//
//                case .success(let payload):
//
//                    MBProgressHUD.hide(for: self.view, animated: true)
//
//                    if let x = payload as? Dictionary<String,AnyObject> {
//
//                        let resultValue = x as NSDictionary
//
//                        if resultValue["non_field_errors"] != nil {
//
//                            self.showErrorsAlertWithOneCancelButton(message: "Вы ввели логин или пароль не правильно!!!")
//                        }
//
//                        else {
//
//                            let token = resultValue["token"] as! String
//                            UserDefaults.standard.set(token, forKey: self.userTokenForUserStandart)
//
//                            self.navigateToMain()
//                        }
//                    }
//
//                case .failure(let error):
//
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом!!!")
//                }
//            })
//        }
//
//        else {
//
//            MBProgressHUD.hide(for: self.view, animated: true)
//            showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
//        }
//    }
    
    
    private func navigateToMain()  {
        performSegue(withIdentifier: "fromLogintoMain", sender: self)
    }
}


