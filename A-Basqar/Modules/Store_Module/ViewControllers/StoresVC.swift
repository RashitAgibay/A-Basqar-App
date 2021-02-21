//
//  StoresVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class StoresVC: DefaultVC, UICollectionViewDataSource, UICollectionViewDelegate, StoreCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var stores = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStore()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath)  as! StoreCell
       
        let singleStore = stores[indexPath.row]
        cell.storeNameLabel.text = singleStore.name
//        cell.employeeLabel.text = "\(singleStore.)"
//        cell.imageView.sd_setImage(with: URL(string: storeImage), placeholderImage: UIImage(named: "img1"))
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigateToStoresEmployees()
    }
    
    func tapEditButton(cell: StoreCell, id: Int) {
        self.navigateToEditStore()
    }

    private func navigateToEditStore() {
        performSegue(withIdentifier: "fromStoES", sender: self)
    }
    
    private func navigateToStoresEmployees() {
        performSegue(withIdentifier: "fromStoSE", sender: self)
    }

    private func getStore() {
        ManagementNetworkManager.service.getUserStore { (stores, error) in
            self.stores = stores ?? [Store]()
            self.collectionView.reloadData()
        }
    }
    
//    func getStoreList() {
//
//            do {
//
//                reachability = try Reachability.init()
//            }
//            catch {
//
//            }
//
//            if ((reachability!.connection) != .unavailable){
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//
//                let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
//
//                let headers: HTTPHeaders = [
//                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
//                    "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
//                ]
//
//                let encodeURL = storeListUrl
//
//                let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
//
//                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
//
////                    print(response.request)
////                    print(response.result)
////                    print(response.response)
//
//                    switch response.result {
//
//                    case .success(let payload):
//                        MBProgressHUD.hide(for: self.view, animated: true)
//
//                        if let x = payload as? Dictionary<String,AnyObject> {
//
//                            print(x)
//                        }
//
//                        else {
//
//                            let resultValue = payload as! NSArray
//
//                            self.storeList = resultValue as! NSArray
//                            self.collectionView.reloadData()
//
//
//                        }
//                    case .failure(let error):
//                        print(error)
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                        self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
//
//                    }
//
//                })
//
//            }
//            else {
//
//                MBProgressHUD.hide(for: self.view, animated: true)
//                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
//
//            }
//
            
//    }
    
}
