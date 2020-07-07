//
//  KassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/7/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class KassaImportVC: UIViewController {

    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var checkNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contrButton: UIButton!
    @IBOutlet weak var factsumButton: UITextField!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var historyID = Int()
    var reachability: Reachability?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        updateUI()
        

    }
    
    private func updateUI() {
        
        perform(#selector(getHistoryList), with: nil, afterDelay: 1)
    }
    
    private func setupView() {
        
        acceptButton.layer.cornerRadius = 20
        acceptButton.dropShadowforButton()
        
        cancelButton.layer.backgroundColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        cancelButton.layer.cornerRadius = 20
        cancelButton.dropShadowforButton()
        
        cardView.layer.cornerRadius = 10
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.dropShadow()
        
        contrButton.layer.cornerRadius = 10
        contrButton.layer.backgroundColor = UIColor.white.cgColor
        contrButton.layer.borderWidth = 1
        contrButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        factsumButton.layer.cornerRadius = 10
        factsumButton.layer.borderWidth = 1
        factsumButton.layer.backgroundColor = UIColor.white.cgColor
        factsumButton.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
    }

    @IBAction func tapBackButton(_ sender: Any) {
        
        self.navigateToMainImport()
    }
    
    @IBAction func tapCheckButton(_ sender: Any) {
    }
    
    @IBAction func tapAcceptButton(_ sender: Any) {
    }
    @IBAction func tapCancelButton(_ sender: Any) {
    }
    
}

extension KassaImportVC {
    
    private func navigateToMainImport() {
        
        performSegue(withIdentifier: "fromKassaToMainImport", sender: self)
    }
}


extension KassaImportVC {
    
    @objc func getHistoryList() {
        
        do {
            
            self.reachability = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        }
        
        if ((reacibility?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = importHistoryList
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request)
//                print(response.result)
//                print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                    
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        
                        let lastHistory = resultValue[0] as! NSDictionary
                        
                        self.parcingData(dict: lastHistory)
//                        print("history: \(lastHistory)")
                                            
                    }
                
                case .failure(let error):
                    
                    print(error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            })
        }
        
        else {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
}

extension KassaImportVC {
    
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

extension KassaImportVC {
    
    private func parcingData(dict: NSDictionary) {
        
        let historyName = dict["history_name"] as! String
        let date = dict["add_time"] as! String
        
        let company = dict["company"] as! NSDictionary
        let contrName = company["company_name"] as! String
        
        let totalSum = dict["sum"] as! Int
        
        self.checkNumberLabel.text = historyName
        self.dateLabel.text = date
        self.contrButton.setTitle(contrName, for: .normal)
        self.factsumButton.text = "\(totalSum)"
        self.totalSumLabel.text = "\(totalSum)"
        
    }
}
