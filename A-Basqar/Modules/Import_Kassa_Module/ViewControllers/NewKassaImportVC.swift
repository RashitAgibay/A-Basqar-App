//
//  NewKassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import RealmSwift
import Printer
import Alamofire



class NewKassaImportVC: DefaultVC {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var importNameButton: UIButton!
    @IBOutlet weak var billNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contragentButton: UIButton!
    @IBOutlet weak var factMoneyTextField: UITextField!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    private var factMoneyBaseValue = Int()
    private var currentContrId = Int()
    private var currentHistoryID = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        setupBillValues()
        setupZeroBillValues()

    }
    
    
    @IBAction func tapAcceptButton(_ sender: Any) {
        
        if contragentButton.titleLabel?.text == "Выбрать" {

            showErrorsAlertWithOneCancelButton(message: "Отсутствует информация")
        }

        else {

            if currentHistoryID != 0 {

                createNewCheck()
                
            }

            if currentContrId != 0 {

                createNullCheck()
            }
            
            var factSumm = String()
            if factMoneyTextField.text == "" {
                factSumm = String(totalSumLabel.text?.split(separator: " ").first ?? "") + " tenge"
            }
            
            generateBillToPrint(number: billNumberLabel.text ?? "",
                                date: dateLabel.text ?? "",
                                contr: contragentButton.titleLabel?.text ?? "",
                                factMoney: factSumm,
                                totalSum: String(totalSumLabel.text?.split(separator: " ").first ?? "") + " tenge",
                                comment: commentLabel.text ?? "")
        }
        

        
    }
    
    
    @IBAction func tapCancelButton(_ sender: Any) {
        
        
        if contragentButton.titleLabel?.text == "Выбрать" {
            
            showErrorsAlertWithOneCancelButton(message: "Отсутствует информация")
        }
        
        else {
            
            cleanAllInfo()
        }
    }
    

    private func setupView() {
        
        acceptButton.layer.cornerRadius = 20
        acceptButton.dropShadowforButton()
        
        declineButton.layer.backgroundColor = UIColor.white.cgColor
        declineButton.layer.borderWidth = 1
        declineButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        declineButton.layer.cornerRadius = 20
        declineButton.dropShadowforButton()
        
        cardView.layer.cornerRadius = 10
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.dropShadow()
        
        importNameButton.layer.cornerRadius = 10
  
        
        contragentButton.layer.cornerRadius = 10
        contragentButton.layer.backgroundColor = UIColor.white.cgColor
        contragentButton.layer.borderWidth = 1
        contragentButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        factMoneyTextField.layer.cornerRadius = 10
        factMoneyTextField.layer.borderWidth = 1
        factMoneyTextField.layer.backgroundColor = UIColor.white.cgColor
        factMoneyTextField.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
    }


}

extension NewKassaImportVC {
    
    private func createNewCheckToApi(historyID: Int, fact_money: String, comment: String) {
            
            do {
                
                self.reachability = try Reachability.init()
            }
            
            catch {
                
                print("unable to start notifier")
            }
            
            if ((reachability?.connection) != .unavailable) {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let token = UserDefaults.standard.string(forKey: userTokenKey) ?? ""
                
                let headers: HTTPHeaders = [
                    
                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                ]
                
                let params: Parameters = [
                    
                    "history":historyID,
                    "fac_money":fact_money.trimmingCharacters(in: .whitespacesAndNewlines),
                    "comments":comment.trimmingCharacters(in: .whitespacesAndNewlines)
                    ]
                
                let encodeURL = exportCheckURL
                
    //            print(params)
                
                let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
//                    print(response.request!)
//                    print(response.result)
//                    print(response.response!)
                    self.cleanAllInfo()
                })
            }
            
            else {
                
                print("internet is not working")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            }
        }
    
    private func createNullChechToApi(contrID: Int, fact_money: String, comment: String) {
                
                do {
                    
                    self.reachability = try Reachability.init()
                }
                
                catch {
                    
                    print("unable to start notifier")
                }
                
                if ((reachability?.connection) != .unavailable) {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    let token = UserDefaults.standard.string(forKey: userTokenKey) ?? ""
                    
                    let headers: HTTPHeaders = [
                        
                        "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                        "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                    ]
                    
                    let params: Parameters = [
                        
                        "company":contrID,
                        "fac_money":fact_money.trimmingCharacters(in: .whitespacesAndNewlines),
                        "comments":comment.trimmingCharacters(in: .whitespacesAndNewlines)
                        ]
                    
                    let encodeURL = exportNullCheckURL
                                        
                    let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                    
                    requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
    //                    print(response.request!)
    //                    print(response.result)
    //                    print(response.response!)
                        self.cleanAllInfo()
                    })
                }
                
                else {
                    
                    print("internet is not working")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            }
    
    
}


extension NewKassaImportVC {
    
    private func getCurrentBillInfo() -> IncomeBill? {
        
        
        var currentBill =  IncomeBill()
        
        let realm = try! Realm()
        var resulsts: Results<IncomeBill>!
        resulsts = realm.objects(IncomeBill.self)

        if resulsts.last != nil {
            
            currentBill = resulsts.last!
            
            return currentBill

        }
        
        else {
            
            return nil
        }
        
                
    }
    
    private func getCurrentContrInfo() -> ImportKassaContragent? {
        
        var currentContr = ImportKassaContragent()
        
        let realm = try! Realm()
        var resulsts: Results<ImportKassaContragent>!
        resulsts = realm.objects(ImportKassaContragent.self)
    
        if resulsts.last != nil {
            
            currentContr = resulsts.last!
            
            return currentContr
        }
        
        else {
            
            return nil
        }
        
    }
    
    private func setupBillValues() {
        
        let currentBill = getCurrentBillInfo()
        
        if currentBill != nil {
            
            importNameButton.setTitle(currentBill?.importNubmer, for: .normal)
            contragentButton.setTitle(currentBill?.contragent, for: .normal)

            billNumberLabel.text = currentBill?.billNumber
            dateLabel.text = currentBill?.date
            
            factMoneyTextField.placeholder = "\(currentBill?.totalMoney ?? 0) тенге"
            totalSumLabel.text = "\(currentBill?.totalMoney ?? 0) тенге"
            
            factMoneyBaseValue = currentBill?.totalMoney ?? 0
            currentHistoryID = currentBill?.historyID ?? 0
        
        }
        
        clearCurrentBillnfo()
    }
    
    private func clearCurrentBillnfo() {
        
        let realm = try! Realm()
        var resulsts: Results<IncomeBill>!
        
        resulsts = realm.objects(IncomeBill.self)
                
        for _ in resulsts.enumerated() {
            
            let bill = resulsts[0]
            
            try! realm.write {
                
                realm.delete(bill)
            }
        }
//        UserDefaults.standard.set(nil, forKey: currentExportBillInfo)
    }
    
    private func setupZeroBillValues() {
        
        let currentContr = getCurrentContrInfo()
        
        if currentContr != nil {
            
            contragentButton.setTitle(currentContr?.contragnetName, for: .normal)
            
            currentContrId = currentContr?.contragentId ?? 0

        }
        
        clearCurrentContrInfo()
        
    }
    
    private func clearCurrentContrInfo() {
        
        let realm = try! Realm()
        var resulsts: Results<ImportKassaContragent>!
        
        resulsts = realm.objects(ImportKassaContragent.self)
                
        for _ in resulsts.enumerated() {
            
            let bill = resulsts[0]
            
            try! realm.write {
                
                realm.delete(bill)
            }
        }
        
        
    }
}


extension NewKassaImportVC {
    
    
    private func createNewCheck() {
        
        if factMoneyTextField.text == "" {
            
            if commentLabel.text == "" {
                
                self.createNewCheckToApi(historyID: currentHistoryID, fact_money: "\(factMoneyBaseValue)", comment: "*")
            }
            
            else {
                
                self.createNewCheckToApi(historyID: currentHistoryID, fact_money: "\(factMoneyBaseValue)", comment: commentLabel.text!)
            }
        }
        
        else {
            
            if commentLabel.text == "" {
                
                self.createNewCheckToApi(historyID: currentHistoryID, fact_money: factMoneyTextField.text ?? "", comment: "*")
            }
            
            else {
                
                self.createNewCheckToApi(historyID: currentHistoryID, fact_money: factMoneyTextField.text ?? "", comment: commentLabel.text!)
            }
        }
    }
    
    private func createNullCheck() {
        
        if factMoneyTextField.text == "" {
            
            showErrorsAlertWithOneCancelButton(message: "Заполните фактическую сумму")
        }
        
        else {
            
            if commentLabel.text == "" {
                
                createNullChechToApi(contrID: currentContrId, fact_money: factMoneyTextField.text ?? "", comment: "*")
            }
            
            else {
                
                createNullChechToApi(contrID: currentContrId, fact_money: factMoneyTextField.text ?? "", comment: commentLabel.text ?? "")

            }
        }
        
    }
    
    private func cleanAllInfo() {
        
        importNameButton.setTitle("Выбрать", for: .normal)
        billNumberLabel.text = "..."
        dateLabel.text = "..."
        contragentButton.setTitle("Выбрать", for: .normal)
        factMoneyTextField.placeholder = "..."
        factMoneyTextField.text = ""
        factMoneyBaseValue = 0
        totalSumLabel.text = "..."
        commentLabel.text = ""
        
    }
    
    private func generateBillToPrint(number: String, date: String, contr: String, factMoney: String, totalSum: String, comment: String) {
        
        
        
        let ticket = Ticket(
            .plainText("--------------------------------"),
            .plainText("////////////////////////////////"),
            .plainText("Nomer checka: \(number)"),
            .plainText("Data: \(date)"),
            .plainText("fact summa: \(factMoney)"),
            .plainText("summa pokupki: \(totalSum)"),
            .plainText("---- made in DalaService.kz ----"),
            .plainText("--------------------------------")
            
        )
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let bluetoothPrinterManager = appDelegate.bluetoothPrinterManager
        
        if bluetoothPrinterManager.canPrint {
            bluetoothPrinterManager.print(ticket)
        }
    }
}
