//
//  KassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/7/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Printer


class KassaImportVC: DefaultVC {

    
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
    var factMoney = Int()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
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
        
        
        createNewCheck()
        
        
        generateBillToPrint(number: checkNumberLabel.text ?? "",
                            date: dateLabel.text ?? "",
                            contr: contrButton.titleLabel?.text ?? "",
                            factMoney: String(factsumButton.text?.split(separator: " ").first ?? "") + " tenge",
                            totalSum: String(totalSumLabel.text?.split(separator: " ").first ?? "") + " tenge",
                            comment: commentTextField.text ?? "")
        
        navigateToMainImport()
    }
    @IBAction func tapCancelButton(_ sender: Any) {
        
        self.navigateToMainImport()
    }
    
}

extension KassaImportVC {
    
    private func navigateToMainImport() {
        
        performSegue(withIdentifier: "fromKassaToMainImport", sender: self)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?
            BluetoothPrinterSelectTableViewController {
            
            let bluetoothPrinterManager = appDelegate.bluetoothPrinterManager

            vc.sectionTitle = "Choose Bluetooth Printer"
            vc.printerManager = bluetoothPrinterManager
        }
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
            
            let encodeURL = importHistoryListURL
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
                    self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            })
        }
        
        else {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    private func createNewCheck(hitoryID: Int, fact_money: Int, testComments: String) {
        
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
            
            let params: Parameters = [
                
                "history":historyID,
                "fac_money":fact_money,
                "comments":testComments.trimmingCharacters(in: .whitespacesAndNewlines)
                ]
            
            let encodeURL = importCheckURL
            
//            print(params)
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
            })
        }
        
        else {
            
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
}


extension KassaImportVC {
    
    private func parcingData(dict: NSDictionary) {
        
        let historyName = dict["history_name"] as! String
        let date = dict["add_time"] as! String
        let historyID = dict["id"] as! Int
        
        let company = dict["company"] as! NSDictionary
        let contrName = company["company_name"] as! String
        
        let totalSum = dict["sum"] as! Int
        
        self.historyID = historyID
        self.factMoney = totalSum
        
        self.checkNumberLabel.text = historyName
        self.dateLabel.text = date
        self.contrButton.setTitle(contrName, for: .normal)
        self.factsumButton.text = "\(totalSum)"
        self.totalSumLabel.text = "\(totalSum)"
                
    }
    
    private func createNewCheck() {
        
        if factsumButton.text == "" {
            
            if commentTextField.text == "" {
                
                self.createNewCheck(hitoryID: self.historyID, fact_money: self.factMoney, testComments: "*")
            }
            
            else {
                
                self.createNewCheck(hitoryID: self.historyID, fact_money: self.factMoney, testComments: commentTextField.text!)
            }
        }
        
        else {
            
            if commentTextField.text == "" {
                
                self.createNewCheck(hitoryID: self.historyID, fact_money: self.factMoney, testComments: "*")
            }
            
            else {
                
                self.createNewCheck(hitoryID: self.historyID, fact_money: self.factMoney, testComments: commentTextField.text!)
            }
        }
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
