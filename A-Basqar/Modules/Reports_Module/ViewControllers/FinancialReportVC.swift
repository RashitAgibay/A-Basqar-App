//
//  FinancialReportVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/9/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class FinancialReportVC: DefaultVC, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    var startDate = Date()
    var endDate = Date()
    
    var startDateMinusOneDay = Date()
    var endDatePlusOneDay = Date()
    
    var startDateString: String = ""
    var endDateString: String = ""
    
    private var datePicker: UIDatePicker?
    var cashReport = CashReport()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desingComponents()
        
        datePicker  = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        let localeID = Locale.preferredLanguages.first
        datePicker?.locale = Locale(identifier: localeID!)
        
        startTextField.inputView = datePicker
        endTextField.inputView = datePicker
        
        makeStartDateTextFiledsDate()
        makeEndDateTextFiledsDate()
        
        startTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(changeStartDate))
        endTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(changeEndingDate))
        
        if #available(iOS 13.4, *) {
            datePicker?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePicker?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            if #available(iOS 14.0, *) {
                datePicker?.preferredDatePickerStyle = .wheels
            } else {
                datePicker?.preferredDatePickerStyle = .wheels
            }
        }
    }
    
    func makeStartDateTextFiledsDate() {
        let date = Date()
        startDate = date
        startDateMinusOneDay = Calendar.current.date(byAdding: .day, value: 0, to: startDate)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        startTextField.text = formatter.string(from: startDate)
        startDateString = formatter.string(from: startDateMinusOneDay)
    }
    
    func makeEndDateTextFiledsDate() {
        let date = Date()
        endDate = date
        endDatePlusOneDay = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        endTextField.text = formatter.string(from: endDate)
        endDateString = formatter.string(from: endDatePlusOneDay)
    }

    @objc func changeStartDate (){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startTextField.text = formatter.string(from: datePicker!.date)
        
        startDate = datePicker!.date
        startDateMinusOneDay = Calendar.current.date(byAdding: .day, value: 0, to: startDate)!
        startDateString = formatter.string(from: startDateMinusOneDay)
    }
    
    @objc func changeEndingDate (){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        endTextField.text = formatter.string(from: datePicker!.date)
        
        endDate = datePicker!.date
        endDatePlusOneDay = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        endDateString = formatter.string(from: endDatePlusOneDay)
    }
    
    @IBAction func tappedSendButton(_ sender: Any) {
        getCashReport()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cashReport.totalBalance != nil {
            return 1
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportsCell", for: indexPath) as! ReportsCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        if cashReport.totalBalance != nil {
            cell.financialStartBalanceLabel.text = "\(cashReport.totalStartBalance ?? 0) тг"
            cell.financialIncomeLabel.text = "\(cashReport.totalIncome ?? 0) тг"
            cell.financialExpensesLabel.text = "\(cashReport.totalExpense ?? 0) тг"
            cell.financialEndBalanceLabel.text = "\(cashReport.totalBalance ?? 0) тг"
        }
        return cell
    }

    func desingComponents() {
        cardView.layer.cornerRadius = 20
        cardView.dropShadow()
        startTextField.layer.cornerRadius = 20
        endTextField.layer.cornerRadius = 20
        sendButton.layer.cornerRadius = 20
        sendButton.dropShadowforButton()
       }
    
    private func getCashReport() {
        ReportNetworkManager.service.getCashReport(dates: ReportDate(startDate: startDateString, endDate: endDateString)) { (cashReport, error) in
            self.cashReport = cashReport ?? CashReport()
            self.collectionVIew.reloadData()
        }
    }
}
