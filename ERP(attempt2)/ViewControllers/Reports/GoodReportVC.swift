//
//  GoodReportVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/10/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class GoodReportVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

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
    
    var reports_list: NSArray = []
    
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
        
    }
    
    
    func makeStartDateTextFiledsDate() {
        
        
        let date = Date()
        startDate = date
        startDateMinusOneDay = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
        
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
        startDateMinusOneDay = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
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
        return reports_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportsCell", for: indexPath) as! ReportsCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        let each_reports = reports_list[indexPath.row] as! NSDictionary

        let good_name = each_reports["goods_name"] as! String
        let start_balance = each_reports["old_goods"] as! Int
        let todays_income_balance = each_reports["import_goods"] as! Int
        let todays_export_balance = each_reports["export_goods"] as! Int
        let end_balance = each_reports["next_goods"] as! Int
        let date = each_reports["add_time"] as! String
        
        cell.nameLabel.text = good_name
//        cell.financialDateReportLabel.text = date
        cell.financialStartBalanceLabel.text = "\(start_balance)"
        cell.financialIncomeLabel.text = "\(todays_income_balance)"
        cell.financialExpensesLabel.text = "\(todays_export_balance)"
        cell.financialEndBalanceLabel.text = "\(end_balance)"
        
        
        return cell
    }
    
    @IBAction func tappedSendButton(_ sender: Any) {
        
        
         get_goods_report_api()
//        debug_print(message: "here is a start date", object: startDateString)
//        debug_print(message: "here is a end date", object: endDateString)
    }
    
    
    func desingComponents() {
        cardview.layer.cornerRadius = 20
        cardview.dropShadow()
        
        startDateTextField.layer.cornerRadius = 20
        endDateTextField.layer.cornerRadius = 20
        
        sendButton.layer.cornerRadius = 20
        sendButton.dropShadowforButton()
    }
}

extension GoodReportVC {
    
    func get_goods_report_api() {
        
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
            
            
            let encodeURL = goodReportUrl
            
//            debug_print(message: "full url", object: encodeURL + "?start_date=\(startDateString)&end_date=\(endDateString)")
            
            let requestOfApi = AF.request(encodeURL + "?start_date=\(startDateString)&end_date=\(endDateString)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                           
//                           print(response.request)
//                           print(response.result)
//                           print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                    
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        self.reports_list = resultValue as! NSArray
                        self.collectionView.reloadData()
                    
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
