//
//  HistoryExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class HistoryExportVC: DefaultVC {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var historyArray = NSArray()
    var historyID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getHistoryList()
    }
    

    
}

extension HistoryExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return historyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "historyExportCell", for: indexPath) as! HistoryExportCell
        
        let singleHistory = historyArray[indexPath.row] as! NSDictionary
        
        let historyName = singleHistory["history_name"] as! String
        let companyName = singleHistory["company"] as! NSDictionary
        let contragentName = companyName["company_name"] as! String
        let date = singleHistory["add_time"] as! String
        let totalPrice  = singleHistory["sum"] as! Int
        
        cell.exportNameLabel.text = historyName
        cell.conrtagentNameLabel.text = contragentName
        cell.dateLabel.text = date
        cell.priceLabel.text = "\(totalPrice)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleHistory = historyArray[indexPath.row] as! NSDictionary
        let historyId = singleHistory["id"] as! Int
        
        self.historyID = historyId
        
        self.navigateToHistoryItem()
        
    }
}


extension HistoryExportVC {
    
    func getHistoryList() {
        
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
            
            let encodeURL = exportHistoryListURL
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
                        
                        self.historyArray = resultValue
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
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
}

extension HistoryExportVC {
    
    private func navigateToHistoryItem() {
        
        performSegue(withIdentifier: "fromHEtoHIE", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromHEtoHIE" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? HistoryItemExportVC {
                destVC.historyID = self.historyID
            }
        }
    }
}
