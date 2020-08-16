//
//  HistoryKassaImportItemVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

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
    var historyId = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
//        print("/// checkID:", checkID)
        getCurrentCheck(checkID: checkID)
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

}

extension HistoryKassaImportItemVC {
    
    
    private func getCurrentCheck(checkID: Int) {
        
        do {
            
            self.reachability = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        }
        
        if ((reacibility?.connection) != .unavailable) {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) ?? ""
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = exportCheckURL + "\(checkID)/"
            print("/// encodeUrl:", encodeURL)
//            print("/// headers:",headers)

            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                
//                print(response.request!)
//                print(response.result)
//                print(response.response!)

            
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let data = payload as? Dictionary<String,AnyObject> {
                        
//                        print("///", x)
                        
                        let company = data["company"] as! NSDictionary
                        let companyName = company["company_name"] as! String
                        
                        let code = data["code"] as! String
                        let date = data["data"] as! String
                        let factMoney = data["fac_money"] as! Int
                        let sumMoney = data["sum_money"] as! Int
                        
                        if data["comment"] != nil {
                            
                            let comment = data["comment"] as! String
                            self.commentLabel.text = comment
                        
                        }
                        
                        self.importNameLabel.text = code
                        self.billNumberLabel.text = code
                        self.dateLabel.text = date
                        self.contragentButton.setTitle(companyName, for: .normal)
                        self.factMoneyTextField.text = "\(factMoney)"
                        self.totalSumLabel.text = "\(sumMoney)"
                        
                    
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
            
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
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


