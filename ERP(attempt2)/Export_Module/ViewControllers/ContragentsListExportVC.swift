//
//  ContragentsListExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class ContragentsListExportVC: DefaultVC {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var contragentsArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getContragentsList()

    }
    
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        self.navigateToMainImport()
    }
    
}


extension ContragentsListExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contragentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "contragentListExportCell", for: indexPath) as! ContragentListExportCell
        
        let singleContr = contragentsArray[indexPath.row] as! NSDictionary
        
        let contrID = singleContr["id"] as! Int
        let contrName = singleContr["company_name"] as! String
        
        cell.delegate = self
        cell.contragentNameLabel.text = contrName
        cell.contrID = contrID
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleContr = contragentsArray[indexPath.row] as! NSDictionary
        
        let contrID = singleContr["id"] as! Int
        let contrName = singleContr["company_name"] as! String
        
        self.saveLastImportContr(contrName: contrName, contrID: contrID)
        
        self.navigateToMainImport()
        
    }
    
    
    
}

extension ContragentsListExportVC {
    
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

extension ContragentsListExportVC: ContragentListExportCellDelegate {
    
    func tapToUpdateContragent(cell: ContragentListExportCell, id: Int) {
        
        self.navigateToUpdateContrInfo()
    }
    
}


extension ContragentsListExportVC {
    
    private func navigateToUpdateContrInfo() {
        
        performSegue(withIdentifier: "fromCLEtoUCE", sender: self)
    }
    
    private func navigateToMainImport() {
        
        performSegue(withIdentifier: "fromCLEtoME", sender: self)
    }
}


extension ContragentsListExportVC {
    
    private func saveLastImportContr(contrName: String, contrID: Int) {
        
        UserDefaults.standard.set(contrName, forKey: selectedExportContr)
        UserDefaults.standard.set(contrID, forKey: selectedExportContrID)
    }
}

