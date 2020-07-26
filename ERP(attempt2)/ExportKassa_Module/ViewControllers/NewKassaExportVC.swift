//
//  NewKassaExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import RealmSwift

class NewKassaExportVC: UIViewController {

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
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        setupBillValues()

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


extension NewKassaExportVC {
    
    private func getCurrentBillInfo() -> OutcomeBill? {
        
        
        var currentBill =  OutcomeBill()
        
        let realm = try! Realm()
        var resulsts: Results<OutcomeBill>!
        resulsts = realm.objects(OutcomeBill.self)

        if resulsts.last != nil {
            
            currentBill = resulsts.last!
            
            return currentBill

        }
        
        else {
            
            return nil
        }
        
                
    }
    
    private func setupBillValues() {
        
        let currentBill = getCurrentBillInfo()
        
        if currentBill != nil {
            
            importNameButton.setTitle(currentBill?.importNubmer, for: .normal)
            billNumberLabel.text = currentBill?.billNumber
            dateLabel.text = currentBill?.date
            contragentButton.setTitle(currentBill?.contragent, for: .normal)
            totalSumLabel.text = "\(currentBill?.totalMoney as! Int) тенге"
        }
        
        clearCurrentBillnfo()
    }
    
    private func clearCurrentBillnfo() {
        
        let realm = try! Realm()
        var resulsts: Results<OutcomeBill>!
        
        resulsts = realm.objects(OutcomeBill.self)
                
        for item in resulsts.enumerated() {
            
            let bill = resulsts[0]
            
            try! realm.write {
                
                realm.delete(bill)
            }
        }
//        UserDefaults.standard.set(nil, forKey: currentExportBillInfo)
    }
}
