//
//  AddNewContrImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/4/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddNewContrImportVC: DefaultVC {

    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contrNameTextField: UITextField!
    @IBOutlet weak var contrPhoneTextField: UITextField!
    @IBOutlet weak var contrBinTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        self.navigateToContrList()
    }
    

    @IBAction func tappedAddButton(_ sender: Any) {
        
        if contrNameTextField.text == "" {
            
            self.showErrorsAlertWithOneCancelButton(message: "Название не может быть пустым")
        }
        
        else {
            
            self.sendContrInfo(companyName: contrNameTextField.text!, bin: contrBinTextField.text!, mobileNumber: contrPhoneTextField.text!)
            self.navigateToContrList()
        }
        
    }
    
    
    private func setupUI() {
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        addButton.layer.cornerRadius = 20
        addButton.dropShadowforButton()
        
        contrNameTextField.delegate = self
        contrPhoneTextField.delegate = self
        contrBinTextField.delegate = self
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrNameTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrPhoneTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrBinTextField)
    }

}

extension AddNewContrImportVC {
    
    func sendContrInfo(companyName: String, bin: String, mobileNumber: String) {
        
        do {
            
            self.reachability = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        
        }
        
        if ((reacibility?.connection) != .unavailable) {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let params = [
                
                "company_name":companyName.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "bin":"\(bin)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "mobile":"\(mobileNumber)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            let encodeURL = importContragentsListURL
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
            
                MBProgressHUD.hide(for: self.view, animated: true)
                
//                print(response.request)
//                print(response.result)
//                print(response.response)
            })
        
        }
        
        else {
            
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
}


extension AddNewContrImportVC {
    
    private func navigateToContrList() {
        
        performSegue(withIdentifier: "fromAddNewContrToContrList", sender: self)
    }
    
}


