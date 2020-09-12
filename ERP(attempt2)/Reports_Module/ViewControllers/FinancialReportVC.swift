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
    
    var report_list: NSArray = []
    
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
        
        get_goods_report_api()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return report_list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportsCell", for: indexPath) as! ReportsCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        let eachReport  = report_list[indexPath.row] as! NSDictionary
        
        let start_balance = eachReport["old_money"] as! Int
        let outcome_money = eachReport["import_money"] as! Int
        let income_money = eachReport["export_money"] as! Int
        let end_balance = eachReport["next_money"] as! Int
        let date = eachReport["add_time"] as! String
        
        cell.financialStartBalanceLabel.text = "\(start_balance)"
        cell.financialIncomeLabel.text = "\(income_money)"
        cell.financialExpensesLabel.text = "\(outcome_money)"
        cell.financialEndBalanceLabel.text = "\(end_balance)"
        
        
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
    
}

extension FinancialReportVC {
    
    func get_goods_report_api() {
        
        do {
            reacibility = try Reachability.init()
        }
        
        catch {
        
        }
        
        if ((reacibility!.connection) != .unavailable){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
            let token = UserDefaults.standard.string(forKey: userTokenKey) ?? ""

            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            
            let encodeURL = financialReportURL + "?start_date=\(startDateString)&end_date=\(endDateString)"
            
//            debug_print(message: "full url", object: encodeURL + "?start_date=\(startDateString)&end_date=\(endDateString)")
            
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                print(response.request)
                print(response.result)
                print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                    
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        self.report_list = resultValue as! NSArray
                        self.collectionVIew.reloadData()
                        
                        
                    
                    }
                
                case .failure(let error):
                    print(error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            })
        }
        
        else {
            
            //print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
}

