//
//  HistoryKassaImportItemVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class HistoryKassaImportItemVC: DefaultVC {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var importNameLabel: UILabel!
    @IBOutlet weak var billNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contragentButton: UIButton!
    @IBOutlet weak var factMoneyTextField: UITextField!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextField!
    
    var checkID = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getBill(billId: checkID)
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        navigateToHistoryKassaItem()
    }
    
    private func setupView() {
        cardView.layer.cornerRadius = 10
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.dropShadow()
        contragentButton.layer.cornerRadius = 10
        contragentButton.layer.backgroundColor = UIColor.white.cgColor
        contragentButton.layer.borderWidth = 1
        contragentButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        contragentButton.isUserInteractionEnabled = false
        factMoneyTextField.layer.cornerRadius = 10
        factMoneyTextField.layer.borderWidth = 1
        factMoneyTextField.layer.backgroundColor = UIColor.white.cgColor
        factMoneyTextField.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        factMoneyTextField.isUserInteractionEnabled = false
        commentLabel.isUserInteractionEnabled = false
      }
    
    private func setupUIBaseValues(importName: String, billNumber: String, date: String, contragent: String, totalSum: String) {
        importNameLabel.text = importName
        billNumberLabel.text = billNumber
        dateLabel.text = date
        contragentButton.setTitle(contragent, for: .normal)
        totalSumLabel.text = totalSum
    }
    
    private func setupUIBaseValues(factMoney: String, comment: String ) {
        factMoneyTextField.text = factMoney
        commentLabel.text = comment
    }
    
    private func getBill(billId: Int) {
        IncomesNetworkManager.service.getIncomesHistoryItem(historyId: billId) { (income, error) in
            
            if income?.exportObject != nil {
                self.importNameLabel.text = "Закуп #\(income?.exportObject?.id ?? 0)"
            }
            else {
                self.importNameLabel.text = "Без Закупа"
            }
            self.billNumberLabel.text = "Чек #\(income?.id ?? 0)"
            self.dateLabel.text = income?.date
            self.contragentButton.setTitle(income?.contragent?.name, for: .normal)
            self.factMoneyTextField.text = income?.fact_cash
            self.totalSumLabel.text = income?.cash_sum
            self.commentLabel.text = income?.comment
        }
    }
}

extension HistoryKassaImportItemVC {
    
    private func navigateToHistoryKassaItem() {
        performSegue(withIdentifier: "fromHKIItoMKI", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHKIItoMKI" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MainKassaImportVC {
                destVC.selectegTag = 1
            }
        }
    }
}


