//
//  AddNewSellerVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddNewSellerVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iinTextView: UITextField!
    @IBOutlet weak var phoneTextView: UITextField!
    @IBOutlet weak var nameOfCompanyTextView: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         cardView.layer.backgroundColor = UIColor.white.cgColor
                          cardView.layer.cornerRadius = 5
                          cardView.dropShadow()
        
        addButton.layer.cornerRadius = 20
        addButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: self.iinTextView)
        activateDelegateForTextField(oneTextField: self.phoneTextView)
        activateDelegateForTextField(oneTextField: self.nameOfCompanyTextView)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: iinTextView)
        freeSpaceOnLeftSideForTextFiedl(someTextField: phoneTextView)
        freeSpaceOnLeftSideForTextFiedl(someTextField: nameOfCompanyTextView)
        
    }
    

    
    @IBAction func addButton(_ sender: UIButton) {
        
        
        if nameOfCompanyTextView.text != ""  {
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
            
            reacibility = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
            }
        
        if ((reacibility!.connection) != .none){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
//                print("token is \(token)")
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let company_name = nameOfCompanyTextView.text as! String
            var company_iin = iinTextView.text as! String
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
        
        performSegue(withIdentifier: "backtotothesellerlist", sender: self)
    }
    
}
