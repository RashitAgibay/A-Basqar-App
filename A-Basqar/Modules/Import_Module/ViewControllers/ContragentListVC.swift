//
//  ContragentListVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/4/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class ContragentListVC: DefaultVC {

    
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


extension ContragentListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contragentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "contragentListCell", for: indexPath) as! ContragentListImportCell
        
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

extension ContragentListVC {
    
    func getContragentsList() {
        
        do {
            
            self.reachability = try Reachability.init()
        
        }
        
        catch {
            
//            print("unable to start notifier")
        }
        
        if ((reachability?.connection) != .unavailable) {
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

extension ContragentListVC: ContragentListImportCellDelegate {
    
    func tapToUpdateContragent(cell: ContragentListImportCell, id: Int) {
        
        self.navigateToUpdateContrInfo()
    }
    
}


extension ContragentListVC {
    
    private func navigateToUpdateContrInfo() {
        
        performSegue(withIdentifier: "fromContrListToUpdateContr", sender: self)
    }
    
    private func navigateToMainImport() {
        
        performSegue(withIdentifier: "fromContrListToMainImport", sender: self)
    }
}


extension ContragentListVC {
    
    private func saveLastImportContr(contrName: String, contrID: Int) {
        
        UserDefaults.standard.set(contrName, forKey: selectedImportContr)
        UserDefaults.standard.set(contrID, forKey: selectedImportContrID)
    }
}
