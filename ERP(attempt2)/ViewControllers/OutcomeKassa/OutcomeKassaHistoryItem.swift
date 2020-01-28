//
//  OutcomeKassaHistoryItem.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/9/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class OutcomeKassaHistoryItem: UIViewController,  UITextFieldDelegate {

   
    @IBOutlet weak var cardVIew: UIView!
 
    @IBOutlet weak var expenceCheckNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var providerNameButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var numberOfCheck: UILabel!
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var factMoneyLabel: UILabel!
    
    
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

//        print("here is a history id \(history_id)")
       
        
//        print("here is a check id \(id_of_check)")
        
        if history_id != 0 {
             get_HistoryList_Api()
        }
        
        get_CheckList_Api()
        
        cardVIew.layer.cornerRadius = 10
        cardVIew.layer.backgroundColor = UIColor.white.cgColor
        cardVIew.dropShadow()
        
        providerNameButton.layer.cornerRadius = 10
        providerNameButton.layer.backgroundColor = UIColor.white.cgColor
        providerNameButton.layer.borderWidth = 1
        providerNameButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        sumTextField.layer.cornerRadius = 10
        sumTextField.layer.borderWidth = 1
        sumTextField.layer.backgroundColor = UIColor.white.cgColor
        sumTextField.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
//        freeSpaceOnLeftSideForTextFiedl(someTextField: sumTextField)
        activateDelegateForTextField(oneTextField: sumTextField)
        activateDelegateForTextField(oneTextField: commentTextField)
        
    }
    
    func activateDelegateForTextField(oneTextField : UITextField){
        
        oneTextField.delegate = self
    }
        

        func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
            someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: someTextField.frame.height))
            someTextField.leftViewMode = UITextField.ViewMode.always
        }
        
       
        
    @IBAction func tappedBackButton(_ sender: Any) {
        performSegue(withIdentifier: "segue100", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue100" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? OutcomeKassaVC {
                targetController.segment_id = segmentID
                
            }
        }
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
    
    
    
    func get_CheckList_Api() {
            
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
                        
                        let encodeURL = buyingChecsUrl
                        
                        let requestOfApi = AF.request(encodeURL + "\(id_of_check)/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                        
                        requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                            
//                            print(response.request)
//                            print(response.result)
//                            print(response.response)
                            
                            switch response.result {

                            case .success(let payload):
                                MBProgressHUD.hide(for: self.view, animated: true)

                                if let x = payload as? Dictionary<String,AnyObject> {
                                    
                                    self.chec_dict = x as! NSDictionary
                                    self.money = self.chec_dict["fac_money"] as! Int
                                    self.comment = self.chec_dict["comments"] as! String
                                    
                                    self.sumTextField.text = "\(self.money)"
                                    self.commentTextField.text = self.comment
                                    
                                    
                                    

                                }

                                else {
                                    let resultValue = payload as! NSArray
                                    
                                }
                            case .failure(let error):
                                print(error)
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")

                            }

                        })
                        
                    }
                    else {
                        //print("internet is not working")
                        MBProgressHUD.hide(for: self.view, animated: true)
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
                
                let encodeURL = buyingHistoryUrl
                
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
                            
                            self.numberOfCheck.text = self.history_name
                            self.expenceCheckNumberLabel.text = self.check_name
                            self.dateLabel.text = self.date
                            self.providerNameButton.setTitle(self.provider_company_name, for: .normal)
                            
                            self.factMoneyLabel.text = "\(self.fact_money)"
                            
                            
                            

                        }

                        else {
//                            let resultValue = payload as! NSArray
                            
                            
                            
                        }
                    case .failure(let error):
                        print(error)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")

                    }

                })
                
            }
            else {
                //print("internet is not working")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                
            }
            
        }
}
