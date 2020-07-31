//
//  HistoryKassaExportItemVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/31/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class HistoryKassaExportItemVC: DefaultVC {

    
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
        print("/// checkID:", checkID)
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
    }
    
    private func setupView() {
          
          cardView.layer.cornerRadius = 10
          cardView.layer.backgroundColor = UIColor.white.cgColor
          cardView.dropShadow()
          
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

extension HistoryKassaExportItemVC {
    
    
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
                    
                    let encodeURL = importCheckURL + "/\(checkID)"
                                    
                    let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                    
                    requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
    //                    print(response.request!)
    //                    print(response.result)
    //                    print(response.response!)
                        
                        switch response.result {
                        
                        case .success(let payload):
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if let x = payload as? Dictionary<String,AnyObject> {
                            
                                print("///", x)
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

