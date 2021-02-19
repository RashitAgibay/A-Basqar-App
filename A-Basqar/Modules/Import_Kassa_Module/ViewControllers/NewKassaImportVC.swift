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
    
    private var factMoneyBaseValue = String()
    private var exportId = Int()
    private var contrId = Int()
    
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
            if exportId != 0 {
                createNewCheck()
            }
            if contrId != 0 {
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

    private func postNewIncomeByExport(exportObject: Int, cash: String, comment: String) {
        let incomeByExport = IncomeByExport(exportObject: exportObject, cash: cash, comment: comment)
        IncomesNetworkManager.service.createIncomeByExport(incomeByExport: incomeByExport) { (message, error) in
            if message?.message == "success" {
                self.cleanAllInfo()
            }
        }
    }
    
    private func postNewIncomeByContr(contrId: Int, cash: String, comment: String) {
        let incomeByContr = IncomeByContr(contragent: contrId, cash: cash, comment: comment)
        IncomesNetworkManager.service.createIncomeByContr(incomeByContr: incomeByContr) { (message, error) in
            if message?.message == "success" {
                self.cleanAllInfo()
            }
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
            self.contrId = currentContr.contragentId
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
            factMoneyTextField.placeholder = "\(currentBill?.totalMoney ?? "") тенге"
            totalSumLabel.text = "\(currentBill?.totalMoney ?? "") тенге"
            factMoneyBaseValue = currentBill?.totalMoney ?? ""
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
    }
    
    private func setupZeroBillValues() {
        let currentContr = getCurrentContrInfo()
        
        if currentContr != nil {
            contragentButton.setTitle(currentContr?.contragnetName, for: .normal)
            contrId = currentContr?.contragentId ?? 0
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
                self.postNewIncomeByExport(exportObject: exportId, cash: factMoneyBaseValue, comment: "*")
            }
            else {
                self.postNewIncomeByExport(exportObject: exportId, cash: factMoneyBaseValue, comment: commentLabel.text!)
            }
        }
        else {
            if commentLabel.text == "" {
                self.postNewIncomeByExport(exportObject: exportId, cash: factMoneyTextField.text ?? "", comment: "*")
            }
            else {
                self.postNewIncomeByExport(exportObject: exportId, cash: factMoneyTextField.text ?? "", comment: commentLabel.text!)
            }
        }
    }
    
    private func createNullCheck() {
        if factMoneyTextField.text == "" {
            showErrorsAlertWithOneCancelButton(message: "Заполните фактическую сумму")
        }
        else {
            if commentLabel.text == "" {
                self.postNewIncomeByContr(contrId: contrId, cash: factMoneyTextField.text ?? "", comment: "*")
            }
            else {
                self.postNewIncomeByContr(contrId: contrId, cash: factMoneyTextField.text ?? "", comment: commentLabel.text ?? "")
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
        factMoneyBaseValue = "0"
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
