//
//  SignInViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 10/28/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//




//MARK: - Логин беті


import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var cardView2: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "new_userTokenKey"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        
        cardView2.layer.backgroundColor = UIColor.white.cgColor
        cardView2.layer.cornerRadius = 5
        cardView2.dropShadow()
        
        loginButton.layer.cornerRadius = 20
        loginButton.dropShadowforButton()
        
        
        
        activateDelegateForTextField(oneTextField: self.loginTextField)
        activateDelegateForTextField(oneTextField: self.passwordTextField2)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: loginTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: passwordTextField2)
        

    }
    

     func activateDelegateForTextField(oneTextField : UITextField){
          oneTextField.delegate = self
      }
      
      func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
          someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: someTextField.frame.height))
          someTextField.leftViewMode = UITextField.ViewMode.always
      }
      
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
          return false
      }
    
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        
        
        if loginTextField.text == "" || passwordTextField2.text == "" {
            print("заполните все поля")
            
            ShowErrorsAlertWithOneCancelButton(title: "Ошибка", message: "Заполните все поля", buttomMessage: "Закрыть")
            
            
        }
        
        else {
            LoginApi()
            
        }
        
        
        
        
        
        
    }
    @IBAction func forgetPasswordButton(_ sender: Any) {
    }
    @IBAction func regisTrationButtonTap(_ sender: Any) {
//        let mainController = MainViewController()
//        present(mainController,animated: true)
        
    }
    
    
    
    func LoginApi() {
        
        do {
            
            self.reacibility = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        
        }
        
        if ((reacibility!.connection) != .none){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let params = [
                
                "username":self.loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "password":self.passwordTextField2.text?.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = "https://abasqar.pythonanywhere.com/auth/v1/api/login/"
            
            print("url: \(encodeURL)")
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                   
                   //print(response.request!)
                   //print(response.result)
                   //print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if let x = payload as? Dictionary<String,AnyObject> {
                        
                        print(x)
                        
                        let resultValue = x as NSDictionary
                        
                        //MARK: - (id412) ddictinary ішінде белгілі бір key бар ма жоқ па соны тексеру үшін
                        
                        if resultValue["error"] != nil {
                            
                            self.ShowErrorsAlertWithOneCancelButton(message: "Вы ввели логин или пароль не правильно!!!")
                        }
                        
                        else {
                            let token = resultValue["token"] as! String
                            
                            print(token)
                            UserDefaults.standard.set(token, forKey: self.userTokenForUserStandart)
                            
//                            print("бұл жерде токен соткада сақталады \(String(describing: UserDefaults.standard.string(forKey: self.userTokenForUserStandart)))")
                             self.toTheNextPage()
                        }
                        
//                        if resultValue["error"] as! String == "Invalid Credentials"{
//                            self.ShowErrorsAlertWithOneCancelButton(message: "Вы ввели логин или пароль не правильно!!!")
//                        }
                    }
                
                case .failure(let error):
                    
                    print(error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом!!!")
                }
            })
        }
        
        else {
            
            print("internet is not working")
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    
    public func toTheNextPage()  {
        performSegue(withIdentifier: "fromlogintomenu", sender: self)
    }
    
    func ShowErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
        
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                   let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in
                       
                   }
                   alertController.addAction(action)
                   self.present(alertController,animated: true, completion: nil)
    }
    
    func ShowErrorsAlertWithOneCancelButton(message: String) {
        
         let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                   let action = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
                       
                   }
                   alertController.addAction(action)
                   self.present(alertController,animated: true, completion: nil)
    }
    
}

