//
//  ContragenListKassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import RealmSwift

class ContragenListKassaImportVC: DefaultVC {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var contragentsArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getContragentsList()

    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        navigateToMainExport()
    }
    
}


extension ContragenListKassaImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contragentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "contragentListExportListCell", for: indexPath) as! ContragentListExportListCell
        
        let singleContr = contragentsArray[indexPath.row] as! NSDictionary
        
        let contrID = singleContr["id"] as! Int
        let contrName = singleContr["company_name"] as! String
        
        cell.conrtagentNameLabel.text = contrName
        cell.contrID = contrID
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleContr = contragentsArray[indexPath.row] as! NSDictionary
        
        let contrID = singleContr["id"] as! Int
        let contrName = singleContr["company_name"] as! String
        
        self.saveContrInfoInSystem(contrName: contrName, contrId: contrID)
//        self.saveLastImportContr(contrName: contrName, contrID: contrID)
        
        self.navigateToMainExport()
        
    }
    
    
    
}

extension ContragenListKassaImportVC {
    
    func getContragentsList() {
        
        do {
            
            self.reachability = try Reachability.init()
        
        }
        
        catch {
            
//            print("unable to start notifier")
        }
        
        if ((reacibility?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = importContragentsListURL
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
                        
                        self.contragentsArray = resultValue
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



extension ContragenListKassaImportVC {
    
    private func navigateToMainExport() {
        
        performSegue(withIdentifier: "fromCLKItoMKI", sender: self)
    }
}



extension ContragenListKassaImportVC {
    
    private func saveContrInfoInSystem(contrName: String, contrId: Int) {
        
        var contr = ImportKassaContragent()
        contr.contragnetName = contrName
        contr.contragentId = contrId
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(contr)
        }

        
    }
    
}
