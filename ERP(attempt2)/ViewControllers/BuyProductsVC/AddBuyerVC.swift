//
//  AddBuyerVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/2/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddBuyerVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iinLabel: UITextField!
    @IBOutlet weak var phoneTextView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var addBuyerButton: UIButton!
    
    var emptyPhoneString: String = ""
    var emptyIINString: String = ""
   
    
    
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "userToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
      
        
           cardView.layer.backgroundColor = UIColor.white.cgColor
                   cardView.layer.cornerRadius = 5
                   cardView.dropShadow()
            
            addBuyerButton.layer.cornerRadius = 20
            addBuyerButton.dropShadowforButton()
            
            activateDelegateForTextField(oneTextField: self.iinLabel)
            activateDelegateForTextField(oneTextField: self.phoneTextView)
            activateDelegateForTextField(oneTextField: self.nameTextView)
            
            freeSpaceOnLeftSideForTextFiedl(someTextField: iinLabel)
            freeSpaceOnLeftSideForTextFiedl(someTextField: phoneTextView)
            freeSpaceOnLeftSideForTextFiedl(someTextField: nameTextView)
        
        
        
        
        
    }
    
    
    @IBAction func tappedAddBuyerButton(_ sender: Any) {
//        print("tapped btn")
        
     
        if nameTextView.text != ""  {
            SendBuyerInfoApi()
            ToTheNextPage()
            
           
            
        }

        else {
            ShowErrorsAlertWithOneCancelButton(message: "Заполните название")
        }
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
    
    func SendBuyerInfoApi() {
        
        do {
            
            self.reacibility = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        }
        
        if ((reacibility!.connection) != .none){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
            print("token is \(token)")
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let company_name = nameTextView.text as! String
            var company_iin = iinLabel.text as! String
            var company_phone = phoneTextView.text as! String
            
            if company_iin == nil {
                company_iin = ""
            }
            
            if company_phone == nil {
                company_phone = ""
            }
                    
//                    print(company_phone)
//                    print(company_iin)
//                    print(company_name)
            
            let params = [
                
                "company_name":company_name.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "bin":company_iin.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "mobile":company_phone.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            let encodeURL = buyerCompaniesUrl
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
            
            })
        }
        else {
            
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
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

    func ToTheNextPage(){
        performSegue(withIdentifier: "backtobuyerlist", sender: self)
    }
    
}
