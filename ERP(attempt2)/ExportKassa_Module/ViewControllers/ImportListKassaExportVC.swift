//
//  ImportListKassaExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import RealmSwift

class ImportListKassaExportVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reachability: Reachability?
    var importHistoryArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImportHistoryList()

    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        navigateToMainKassaExport()
    }
    


}

extension ImportListKassaExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return importHistoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "importListKassaExportCell", for: indexPath) as! ImportListKassaExportCell
        
        let singleHistory = importHistoryArray[indexPath.row] as! NSDictionary
        
        let companyName = singleHistory["company"] as! NSDictionary
        let contragentName = companyName["company_name"] as! String
        let date = singleHistory["add_time"] as! String
        let totalPrice  = singleHistory["sum"] as! Int
        
        cell.contragentNameLabel.text = contragentName
        cell.dateLabel.text = date
        cell.priceLabel.text = "\(totalPrice) тенге"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleHistory = importHistoryArray[indexPath.row] as! NSDictionary
        
        let historyName = singleHistory["history_name"] as! String
        let code = singleHistory["code"] as! String
        let companyName = singleHistory["company"] as! NSDictionary
        let contragentName = companyName["company_name"] as! String
        let date = singleHistory["add_time"] as! String
        let totalPrice  = singleHistory["sum"] as! Int
        
//        print("---", historyName, code)
        
        self.saveCurrentBillInSystem(importName: historyName, billNumber: code, date: date, contragent: contragentName, totalMoney: totalPrice)
        
    }
    
}

extension ImportListKassaExportVC {
    
    private func navigateToMainKassaExport() {
        
        performSegue(withIdentifier: "fromImportListKassaExportToMainKassaExport", sender: self)
    }
}


extension ImportListKassaExportVC {
    
    func getImportHistoryList() {
        
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
                        
                        self.importHistoryArray = resultValue
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
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
}

extension ImportListKassaExportVC {
    
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

extension ImportListKassaExportVC {
    
    private func saveCurrentBillInSystem(importName: String, billNumber: String, date: String, contragent: String, totalMoney: Int) {
        
        var bill = OutcomeBill()
        bill.importNubmer = importName
        bill.billNumber = billNumber
        bill.date = date
        bill.contragent = contragent
        bill.totalMoney = totalMoney
        
//        print("bill info: \(bill.billNumber)")
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(bill)
        }
        
        var resulsts: Results<OutcomeBill>!
        resulsts = realm.objects(OutcomeBill.self)
        
        if resulsts.last != nil {
             

//            print(resulsts.last as! Bill)
            
//             for item in resulsts {
//
//                 print("--- ", item.contragent)
//                 print("--- ", item.billNumber)
//                 print("--- ", item.date)
//                 print("--- ", item.importNubmer)
//
//             }

         }

        
//        UserDefaults.standard.set(bill, forKey: "currentExportBillInfo")
        
        navigateToMainKassaExport()
        
    }
}
