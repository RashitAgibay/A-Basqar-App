//
//  OutcomeKassaFirstPage.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/9/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit
import Printer

class OutcomeKassaFirstPage: UIViewController,  UITextFieldDelegate  {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var checkNumberButton: UIButton!
    @IBOutlet weak var outcomeCheck: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var provider: UIButton!
    @IBOutlet weak var factMoneyTextfield: UITextField!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var history_item_dict: NSDictionary = [:]
    var history_id_in_list: Int = 0
    var checkName: String = ""
    var date: String = ""
    var companyName: String = ""
    var sum: String = ""
    var factSum: Int = 0
    var comment: String = " "
    
    var emptyString: String = "***"
    
     var company_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if history_id_in_list != 0 {
            getHistoryApi()
        }
        
        
        if companyName == "" {
            provider.setTitle("Выбрать", for: .normal)
        }
        
        else {
            provider.setTitle(companyName, for: .normal)
        }
        
        
//        print("here is the \(history_id_in_list)")
        factMoneyTextfield.placeholder = "0"
        
        acceptButton.layer.cornerRadius = 20
        acceptButton.dropShadowforButton()
        
        checkNumberButton.layer.cornerRadius = 10
        
        cancelButton.layer.backgroundColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        cancelButton.layer.cornerRadius = 20
        cancelButton.dropShadowforButton()
        
        cardView.layer.cornerRadius = 10
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.dropShadow()
        
        provider.layer.cornerRadius = 10
        provider.layer.backgroundColor = UIColor.white.cgColor
        provider.layer.borderWidth = 1
        provider.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
               
              
        
               
               factMoneyTextfield.layer.cornerRadius = 10
               factMoneyTextfield.layer.borderWidth = 1
               factMoneyTextfield.layer.backgroundColor = UIColor.white.cgColor
               factMoneyTextfield.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
               
               
               
//               freeSpaceOnLeftSideForTextFiedl(someTextField: factMoneyTextfield)
               activateDelegateForTextField(oneTextField: factMoneyTextfield)
               
               activateDelegateForTextField(oneTextField: commentTextField)
        

    }
    

    func activateDelegateForTextField(oneTextField : UITextField){
         oneTextField.delegate = self
     }
     

     func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
         someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: someTextField.frame.height))
         someTextField.leftViewMode = UITextField.ViewMode.always
     }
     
    func generateBillToPrint(number: String, date: String, contr: String, factMoney: String, totalSum: String, comment: String) {
        
        
        
        let ticket = Ticket(
            .plainText("--------------------------------"),
            .plainText("Nomer checka: \(number)"),
            .plainText("Data: \(date)"),
            .plainText("fact summa: \(factMoney)"),
            .plainText("summa pokupki: \(totalSum)"),
            .plainText("--------------------------------")
            
        )
        
        if bluetoothPrinterManager.canPrint {
            bluetoothPrinterManager.print(ticket)
        }
    }
    
    @IBAction func tappedAcceptButton(_ sender: Any) {
        

//        sum = factMoneyTextField.text as! String
        
        if commentTextField.text == "" {
            comment = "*"
        //            debug_print(message: "here is a comment:", object: comment)
        
        }
        else {
            comment = commentTextField.text as! String
        //            debug_print(message: "here is a comment:", object: comment)
        }
                
        //        //
        //                print("here is the history id \(history_id_in_list)")
        //                print("here is the fact_mooney \(sum)")
        //                print("here is the comment \(comment)")
        
        if factMoneyTextfield.text == "" {
            ShowErrorsAlertWithOneCancelButton(message: "Введите фактическую сумму")
        }
        
        else {
            
            if checkName == "" {
                send_Null_Check_To_CheckList_Api()
            }
            
            generateBillToPrint(number: checkNumberButton.titleLabel!.text!, date: dateLabel.text!, contr: provider.titleLabel!.text!, factMoney: factMoneyTextfield.text!, totalSum: totalMoneyLabel.text!, comment: commentTextField.text!)
            
            ShowErrorsAlertWithOneCancelButton(title: "Успешно", message: "Добавлен новый кассовый документ", buttomMessage: "Закрыть")
            send_Check_To_CheckList_Api()
            makeNullAllUIValues()
        }
    }
    
     
    @IBAction func tappedCancelButton(_ sender: Any) {
        makeNullAllUIValues()
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
    
    func makeNullAllUIValues(){
        self.checkNumberButton.setTitle("Выбрать...", for: .normal)
        self.outcomeCheck.text = "..."
        self.dateLabel.text = "..."
        self.provider.setTitle("...", for: .normal)
        self.factMoneyTextfield.text = nil
        self.factMoneyTextfield.placeholder = "0"
        self.totalMoneyLabel.text = "0"
        self.commentTextField.text = nil
        self.commentTextField.placeholder = "Введите сюда ваш комментарий..."
    }

    func getHistoryApi() {
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
                    
                    let requestOfApi = AF.request(encodeURL + "\(history_id_in_list)/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                    
                    requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                        
        //                print(response.request)
        //                print(response.result)
        //                print(response.response)
                        
                        switch response.result {

                        case .success(let payload):
                            MBProgressHUD.hide(for: self.view, animated: true)

                            if let x = payload as? Dictionary<String,AnyObject> {

                                self.history_item_dict = x as NSDictionary
                                
                                self.checkName = self.history_item_dict["history_name"] as! String
                                self.history_id_in_list = self.history_item_dict["id"] as! Int
                                self.date = self.history_item_dict["add_time"] as! String
                                self.factSum = self.history_item_dict["sum"] as! Int

                                let company = self.history_item_dict["company"] as! NSDictionary

                                self.companyName = company["company_name"] as! String


                                self.checkNumberButton.setTitle(self.checkName, for: .normal)
                                self.outcomeCheck.text = self.checkName
                                self.dateLabel.text = self.date
                                self.provider.setTitle(self.companyName, for: .normal)
                                self.totalMoneyLabel.text = "\(self.factSum)"
                                
                                
                                
                                

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
                
                "history":"\(self.history_id_in_list)".trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                "fac_money":self.factMoneyTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                "comments":self.comment.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
            ]
            
            let encodeURL = buyingChecsUrl
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
            })
        }
        else {
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    func send_Null_Check_To_CheckList_Api() {
            
            
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
                    
                    "company":"\(self.company_id)".trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                    "fac_money":self.factMoneyTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                    "comments":self.comment.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                ]
                
                let encodeURL = nullOutcomeKassaUrl
                let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                        
    //                    print(response.request!)
    //                    print(response.result)
    //                    print(response.response)
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
}
