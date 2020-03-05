//
//  KassaDocVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/3/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit
import Printer

class KassaDocVC: UIViewController,  UITextFieldDelegate {

    private var bluetoothPrinterManager = BluetoothPrinterManager()
    private let dummyPrinter = DummyPrinter()
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var checkNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companyNameButton: UIButton!

    
    @IBOutlet weak var fact_sum: UITextField!
    @IBOutlet weak var buy_sum: UILabel!
    
    
    @IBOutlet weak var commentTextView: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButon: UIButton!
    
    @IBOutlet weak var collectionView: UIView!
    
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

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        acceptButton.layer.cornerRadius = 20
        acceptButton.dropShadowforButton()
        
        cancelButon.layer.backgroundColor = UIColor.white.cgColor
        cancelButon.layer.borderWidth = 1
        cancelButon.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        cancelButon.layer.cornerRadius = 20
        cancelButon.dropShadowforButton()
        
        
        cardView.layer.cornerRadius = 10
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.dropShadow()
        
        companyNameButton.layer.cornerRadius = 10
        companyNameButton.layer.backgroundColor = UIColor.white.cgColor
        companyNameButton.layer.borderWidth = 1
        companyNameButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
       
        
        fact_sum.layer.cornerRadius = 10
        fact_sum.layer.borderWidth = 1
        fact_sum.layer.backgroundColor = UIColor.white.cgColor
        fact_sum.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        
        
//        freeSpaceOnLeftSideForTextFiedl(someTextField: buy_sum)
        activateDelegateForTextField(oneTextField: fact_sum)
        
        activateDelegateForTextField(oneTextField: commentTextView)
    

        self.checkNumberLabel.text = self.checkName
        self.dateLabel.text = self.date
        self.companyNameButton.setTitle(self.companyName, for: .normal)
        self.fact_sum.text = "\(self.factSum)"
        self.buy_sum.text = "\(self.factSum)"
        self.sum = "\(self.factSum)"
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //MARK: - бір функцияға хадеожка қою үшін
        perform(#selector(getHistoryApi), with: nil, afterDelay: 1)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BluetoothPrinterSelectTableViewController {
            vc.sectionTitle = "Выберите принтер"
            vc.printerManager = bluetoothPrinterManager
        }
    }
    
    @IBAction func tapAcceptButton(_ sender: Any) {
        sum = fact_sum.text!
        
        if commentTextView.text == "" {
            comment = "*"
        //            debug_print(message: "here is a comment:", object: comment)
        }
        else {
            comment = commentTextView.text as! String
        //            debug_print(message: "here is a comment:", object: comment)
        }
        
//        let ticket = Ticket(
//            .plainText("этот принтер работает")
//        )
//
//        if bluetoothPrinterManager.canPrint {
//            bluetoothPrinterManager.print(ticket)
//        }
//
//        dummyPrinter.print(ticket)
//
        generateBillToPrint(number: checkNumberLabel.text!, date: dateLabel.text!, contr: companyNameButton.titleLabel!.text!, factMoney: fact_sum.text!, totalSum: buy_sum.text!, comment: commentTextView.text!)
        send_Check_To_CheckList_Api()
        performSegue(withIdentifier: "fromkassadoctobuypage", sender: self)
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
    
    @IBAction func tapCancelButton(_ sender: Any) {
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
}

//MARK: - Here is a Api works
extension KassaDocVC {
    
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
                
                let encodeURL = buyingHistoryUrl
                
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
                            self.reversed_history_list = self.history_list.reversed() as NSArray
                            
                            let last_element = self.reversed_history_list[0] as! NSDictionary
                            
                            self.checkName = last_element["history_name"] as! String
                            self.historyId = last_element["id"] as! Int
                            self.date = last_element["add_time"] as! String
                            self.factSum = last_element["sum"] as! Int
                            
                            let company = last_element["company"] as! NSDictionary
                            
                            self.companyName = company["company_name"] as! String

                            self.checkNumberLabel.text = self.checkName
                            self.dateLabel.text = self.date
                            self.companyNameButton.setTitle(self.companyName, for: .normal)
                            self.fact_sum.text = "\(self.factSum)"
                            self.buy_sum.text = "\(self.factSum)"
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
            
            let encodeURL = buyingChecsUrl
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                               
//                               print(response.request!)
//                               print(response.result)
//                               print(response.response)
            })
        }
            
        else {
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
        
        
}

//MARK: - Here is a alerts
extension KassaDocVC {
    
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
