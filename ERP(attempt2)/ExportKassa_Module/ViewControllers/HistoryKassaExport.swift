//
//  HistoryKassaExport.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class HistoryKassaExport: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reachability: Reachability?
    var historyKassaExportList = NSArray()

    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getChecksList()
        collectionView.refreshControl = refreshControl

    }
    
    
    @objc private func refreshData(sender: UIRefreshControl) {
        
        getChecksList()
        sender.endRefreshing()
    
    }
    
}

extension HistoryKassaExport: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return historyKassaExportList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "historyKassaExportCell", for: indexPath) as! HistoryKassaExportCell
        
        let singleBill = historyKassaExportList[indexPath.row] as! NSDictionary
        let billId = singleBill["id"] as! Int
        let billName = singleBill["code"] as! String
        let date = singleBill["data"] as! String

        let company = singleBill["company"] as! NSDictionary
        let price = singleBill["fac_money"] as! Int
        
        let contragent = company["company_name"] as! String
        
        cell.billLabel.text = billName
        cell.contragentNameLabel.text = contragent
        cell.dateLabel.text = date
        cell.priceLabel.text = "\(price) тенге"
        
        return cell
    }
    
    
    
}

extension HistoryKassaExport {
    
    private func getChecksList() {
            
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
                
                let encodeURL = importCheckURL
                                
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
                        
                        }
                        
                        else {
                            
                            let resultValue = payload as! NSArray
                            
                            self.historyKassaExportList = resultValue
                            self.historyKassaExportList = self.historyKassaExportList.reversed() as NSArray
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
                
                print("internet is not working")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            }
        }
    
}

extension HistoryKassaExport {
    
    
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
