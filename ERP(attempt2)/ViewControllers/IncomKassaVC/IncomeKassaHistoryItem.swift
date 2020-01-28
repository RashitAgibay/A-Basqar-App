//
//  IncomeKassaHistoryItem.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/6/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class IncomeKassaHistoryItem: UIViewController,  UITextFieldDelegate {

    
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var seliingNumber: UILabel!
    @IBOutlet weak var checkNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companyNameButton: UIButton!
    @IBOutlet weak var factCachTextField: UITextField!
    @IBOutlet weak var totalCashLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!

    
    var history_id: Int = 0
    var id_of_check: Int = 0
    
    var history_name: String = ""
    var check_name: String = ""
    var date: String = ""
    var provider_company_name: String = ""
    var money: Int = 0
    var fact_money: Int = 0
    var comment: String = ""
    
    var chec_dict: NSDictionary = [:]
    var history_dict: NSDictionary = [:]
    
    var segmentID: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        debug_print(message: "history id", object: history_id)
//        debug_print(message: "check id ", object: id_of_check)
        
        
        
        if history_id != 0 {
            get_HistoryList_Api()
        }
        
        get_CheckList_Api()
        
        cardView.layer.cornerRadius = 10
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.dropShadow()
        
        companyNameButton.layer.cornerRadius = 10
        companyNameButton.layer.backgroundColor = UIColor.white.cgColor
        companyNameButton.layer.borderWidth = 1
        companyNameButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        factCachTextField.layer.cornerRadius = 10
        factCachTextField.layer.borderWidth = 1
        factCachTextField.layer.backgroundColor = UIColor.white.cgColor
        factCachTextField.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        activateDelegateForTextField(oneTextField: factCachTextField)
        activateDelegateForTextField(oneTextField: commentTextField)
        
    }
    
    
    func activateDelegateForTextField(oneTextField : UITextField){
         oneTextField.delegate = self
    }
    
    func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
         someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: someTextField.frame.height))
         someTextField.leftViewMode = UITextField.ViewMode.always
    }
     
    
     
     
     

     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         self.view.endEditing(true)
         return false
     }
     
     
    
     
     //MARK: - (id - 4651) Кез келген hex кодттағы түсті UIColor типіне ауыстыру
     public func hexStringToUIColor (hex:String) -> UIColor {
         var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

         if (cString.hasPrefix("#")) {
             cString.remove(at: cString.startIndex)
         }

         if ((cString.count) != 6) {
             return UIColor.gray
         }

         var rgbValue:UInt64 = 0
         Scanner(string: cString).scanHexInt64(&rgbValue)

         return UIColor(
             red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
             green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
             blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
             alpha: CGFloat(1.0)
         )
     }
    
    
    @IBAction func tappedBackButton(_ sender: Any) {
        performSegue(withIdentifier: "bactosellerkass", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bactosellerkass" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? IncomeKassaVC {
                targetController.segment_id = segmentID
            }
        }
    }
    

}

extension IncomeKassaHistoryItem {
    
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


extension IncomeKassaHistoryItem {
    
    func get_CheckList_Api() {
        
        do {
            
            reacibility = try Reachability.init()
        }
        
        catch {
        
        }
        
        if ((reacibility!.connection) != .unavailable){
            
            //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
            let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
            let headers: HTTPHeaders = [
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = sellingKassaUrl
            
            let requestOfApi = AF.request(encodeURL + "\(id_of_check)/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                                
    //                            print(response.request)
    //                            print(response.result)
    //                            print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    if let x = payload as? Dictionary<String,AnyObject> {
                        
                        self.chec_dict = x as! NSDictionary
                        self.money = self.chec_dict["fac_money"] as! Int
                        self.comment = self.chec_dict["comments"] as! String
                        self.factCachTextField.text = "\(self.money)"

                        self.commentTextField.text = self.comment
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                    }
                
                case .failure(let error):
                    print(error)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            })
        
        }
        
        else {
            
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    
    func get_HistoryList_Api() {
        
        do {
            reacibility = try Reachability.init()
        }
        
        catch {
        
        }
        
        if ((reacibility!.connection) != .unavailable){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
            let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = sellingHistoryUrl
            
            let requestOfApi = AF.request(encodeURL + "\(history_id)/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                        
    //                    print(response.request)
    //                    print(response.result)
    //                    print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                        self.history_dict = x as! NSDictionary
                        self.history_name = self.history_dict["history_name"] as! String
                        self.check_name = self.history_dict["code"] as! String
                        self.date = self.history_dict["add_time"] as! String
                        
                        let company = self.history_dict["company"] as! NSDictionary
                        self.provider_company_name = company["company_name"] as! String
                        self.fact_money = self.history_dict["sum"] as! Int
                        
                        self.seliingNumber.text = self.history_name
                        self.checkNumberLabel.text = self.check_name
                        self.dateLabel.text = self.date
                        self.companyNameButton.setTitle(self.provider_company_name, for: .normal)
                        
                        self.totalCashLabel.text = "\(self.fact_money)"
                    }
                    
                    else {
                    
                    }
                
                case .failure(let error):
                    print(error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            })
        }
        else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    
    }
}
