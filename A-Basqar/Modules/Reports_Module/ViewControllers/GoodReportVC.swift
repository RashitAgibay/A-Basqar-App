//
//  GoodReportVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/10/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class GoodReportVC: DefaultVC, UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var cardview: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var startDate = Date()
    var endDate = Date()
    
    var startDateMinusOneDay = Date()
    var endDatePlusOneDay = Date()
    
    var startDateString: String = ""
    var endDateString: String = ""
    
    var reportProducts = [ProductReport]()
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desingComponents()
        
        datePicker  = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        let localeID = Locale.preferredLanguages.first
        datePicker?.locale = Locale(identifier: localeID!)
        
        startDateTextField.inputView = datePicker
        endDateTextField.inputView = datePicker
        
        makeStartDateTextFiledsDate()
        makeEndDateTextFiledsDate()
        
        startDateTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(changeStartDate))
        endDateTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(changeEndingDate))
        
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
        
        startDateTextField.text = formatter.string(from: startDate)
        startDateString = formatter.string(from: startDateMinusOneDay)
    }
    
    func makeEndDateTextFiledsDate() {
        let date = Date()
        endDate = date
        endDatePlusOneDay = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        endDateTextField.text = formatter.string(from: endDate)
        endDateString = formatter.string(from: endDatePlusOneDay)
    }

    @objc func changeStartDate (){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDateTextField.text = formatter.string(from: datePicker!.date)
        
        startDate = datePicker!.date
        startDateMinusOneDay = Calendar.current.date(byAdding: .day, value: 0, to: startDate)!
        startDateString = formatter.string(from: startDateMinusOneDay)
    }
    
    @objc func changeEndingDate (){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        endDateTextField.text = formatter.string(from: datePicker!.date)
        
        endDate = datePicker!.date
        endDatePlusOneDay = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        endDateString = formatter.string(from: endDatePlusOneDay)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reportProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportsCell", for: indexPath) as! ReportsCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        let currentReport = reportProducts[indexPath.row]
        cell.nameLabel.text = currentReport.name
        cell.financialStartBalanceLabel.text = currentReport.startCount
        cell.financialEndBalanceLabel.text = currentReport.endCount
        cell.financialIncomeLabel.text = currentReport.importCount
        cell.financialExpensesLabel.text = currentReport.exportCount
        
        return cell
    }
    
    @IBAction func tappedSendButton(_ sender: Any) {
        getReportProducts()
    }
    
    func desingComponents() {
        cardview.layer.cornerRadius = 20
        cardview.dropShadow()
        startDateTextField.layer.cornerRadius = 20
        endDateTextField.layer.cornerRadius = 20
        sendButton.layer.cornerRadius = 20
        sendButton.dropShadowforButton()
    }
    
    private func getReportProducts() {
        ReportNetworkManager.service.getProductsReport(dates: ReportDate(startDate: startDateString, endDate: endDateString)) { (reportProds, error) in
            self.reportProducts = reportProds ?? [ProductReport]()
            self.collectionView.reloadData()
        }
    }
}
