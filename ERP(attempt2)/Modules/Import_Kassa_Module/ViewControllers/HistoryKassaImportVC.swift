//
//  HistoryKassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class HistoryKassaImportVC: DefaultVC {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var historyKassaExportList = NSArray()
    var checkId = Int()
    var historyId = Int()

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

extension HistoryKassaImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return historyKassaExportList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "historyKassaExportCell", for: indexPath) as! HistoryKassaExportCell
        
        let singleBill = historyKassaExportList[indexPath.row] as! NSDictionary
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleBill = historyKassaExportList[indexPath.row] as! NSDictionary
        let billId = singleBill["id"] as! Int
        
        if singleBill["history"] as? NSDictionary != nil {

            let history = singleBill["history"] as! NSDictionary
            let historyId = history["id"] as! Int
            self.historyId = historyId
//            print("/// history", singleBill["history"])

        }
        
//        print("/// history", singleBill["history"])
        
        self.checkId = billId
        
        self.navigateToHistoryKassaItem()
        
    }
    
}

extension HistoryKassaImportVC {
    
    private func getChecksList() {
            
            do {
                
                self.reachability = try Reachability.init()
            }
            
            catch {
                
                print("unable to start notifier")
            }
            
            if ((reachability?.connection) != .unavailable) {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let token = UserDefaults.standard.string(forKey: userTokenKey) ?? ""
                
                let headers: HTTPHeaders = [
                    
                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                ]
                
                let encodeURL = exportCheckURL
//                print("/// -encodeUrl:", encodeURL)
//                print("/// -headers:",headers)
                                
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
                        self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                    }
                })
            }
            
            else {
                
                print("internet is not working")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            }
        }
    
}

extension HistoryKassaImportVC {
    
    private func navigateToHistoryKassaItem() {

        performSegue(withIdentifier: "fromHKItoHKII", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromHKItoHKII" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? HistoryKassaImportItemVC {
                destVC.checkID = self.checkId

                if self.historyId != 0 {

                    destVC.historyId = self.historyId
                }
            }
        }
    }
}



