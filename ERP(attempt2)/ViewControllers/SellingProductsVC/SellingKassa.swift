//
//  SellingKassa.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class SellingKassa: UIViewController,  UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sellingCheckLabel: UILabel!
    @IBOutlet weak var sellingDateLabel: UILabel!
    @IBOutlet weak var sellingCompanyNameButton: UIButton!

    
    
    @IBOutlet weak var factMoneyLabel: UITextField!
    @IBOutlet weak var sumTextField: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var history_list: NSArray = []
    var reversed_history_list: NSArray = []
    var checkName: String = ""
    var historyId: Int = 0
    var date: String = ""
    var companyName: String = ""
    var sum: String = ""
    var factSum: Int = 0
    var comment: String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()

        acceptButton.layer.cornerRadius = 20
         acceptButton.dropShadowforButton()
         
         cancelButton.layer.backgroundColor = UIColor.white.cgColor
         cancelButton.layer.borderWidth = 1
         cancelButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
         cancelButton.layer.cornerRadius = 20
         cancelButton.dropShadowforButton()
         
         
         cardView.layer.cornerRadius = 10
         cardView.layer.backgroundColor = UIColor.white.cgColor
         cardView.dropShadow()
         
         sellingCompanyNameButton.layer.cornerRadius = 10
         sellingCompanyNameButton.layer.backgroundColor = UIColor.white.cgColor
         sellingCompanyNameButton.layer.borderWidth = 1
         sellingCompanyNameButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
         
        
         
         factMoneyLabel.layer.cornerRadius = 10
         factMoneyLabel.layer.borderWidth = 1
         factMoneyLabel.layer.backgroundColor = UIColor.white.cgColor
         factMoneyLabel.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
         
         
         
//         freeSpaceOnLeftSideForTextFiedl(someTextField: factPriceTextField)
         activateDelegateForTextField(oneTextField: factMoneyLabel)
         
         activateDelegateForTextField(oneTextField: commentTextField)
        
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        perform(#selector(getHistoryApi), with: nil, afterDelay: 1)
       
    }
    
    
    @IBAction func tappedAcceptButton(_ sender: Any) {
        
//        comment = commentTextField.text as! String
        sum = factMoneyLabel.text as! String
//
//        print("here is the history id \(historyId)")
//        print("here is the fact_mooney \(sum)")
//        print("here is the comment \(comment)")
        
        if commentTextField.text == "" {
                    comment = "*"
        //            debug_print(message: "here is a comment:", object: comment)
                    
                }
                else {
                    comment = commentTextField.text as! String
        //            debug_print(message: "here is a comment:", object: comment)
                }
        
        send_Check_To_CheckList_Api()
        performSegue(withIdentifier: "onemoreidentifre123", sender: self)
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
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

}



extension SellingKassa {
    
    @objc func getHistoryApi() {
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
                
                let encodeURL = sellingHistoryUrl
                
                let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                    
    //                print(response.request)
    //                print(response.result)
    //                print(response.response)
                    
                    switch response.result {

                    case .success(let payload):
                        MBProgressHUD.hide(for: self.view, animated: true)

                        if let x = payload as? Dictionary<String,AnyObject> {
                            print(x)
                            //let resultValue = x as NSMutableArray
                            //categoryInfo = NSMutableArray(array: resultValue) as! NSArray

                        }

                        else {
                            let resultValue = payload as! NSArray
                            //print("осы жерде категори инфо")
                            //    print(resultValue)

                            self.history_list = NSMutableArray(array: resultValue)
//                            self.reversed_history_list = self.history_list.reversed() as NSArray
                            
                            let last_element = self.history_list[0] as! NSDictionary
                            
//                            print("here is a \(self.history_list[0])")
                            
                            self.checkName = last_element["history_name"] as! String
                            self.historyId = last_element["id"] as! Int
                            self.date = last_element["add_time"] as! String
                            self.factSum = last_element["sum"] as! Int
                            
//                            print("here is a \(last_element["sum"])")
                            
                            let company = last_element["company"] as! NSDictionary
                            
                            self.companyName = company["company_name"] as! String

                            self.sellingCheckLabel.text = self.checkName
                            self.sellingDateLabel.text = self.date
                            self.sellingCompanyNameButton.setTitle(self.companyName, for: .normal)
                            self.factMoneyLabel.text = "\(self.factSum)"
                            self.sumTextField.text = "\(self.factSum)"
                            self.sum = "\(self.factSum)"
                            
//                            print("here is the \(self.reversed_history_list)")
//                            print("here os the first elemtn \(self.reversed_history_list[0])")
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
    
    
    func send_Check_To_CheckList_Api() {


            

            do {

                reacibility = try Reachability.init()
            }

            catch {
                print("unable to start notifier")
            }

            if ((reacibility!.connection) != .none){

                let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String

                let headers: HTTPHeaders = [

                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                ]

                let params = [

                    "history":"\(self.historyId)".trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                    "fac_money":"\(self.sum)".trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                    "comments":self.comment.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                ]
                
                let encodeURL = sellingKassaUrl

                let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)

                requestOfApi.responseJSON(completionHandler: {(response)-> Void in

//                                   print(response.request!)
//                                   print(response.result)
//                                   print(response.response)
                })
            }

            else {
                print("internet is not working")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            }
        }
        
        
}


extension SellingKassa {
    
    func ShowErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in}
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
