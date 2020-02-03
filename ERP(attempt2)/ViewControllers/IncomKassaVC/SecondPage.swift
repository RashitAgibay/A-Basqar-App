//
//  SecondPage.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/6/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit
import SwipeCellKit

class SecondPage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SwipeCollectionViewCellDelegate  {
   
    
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var info_array: NSArray = []
    var reversed_info_array: NSArray = []
    var idOfCheck: Int = 0
    var idOfHistory: Int = 0
    
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
    }()
    
    @objc private func refreshData(sender: UIRefreshControl){
        get_CheckList_Api()
        self.collectionView.reloadData()
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = refreshControl
        get_CheckList_Api()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info_array.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "incomeCell", for: indexPath) as! IncomeKassaCheckCell
        
        cell.delegate = self
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.imageView.layer.cornerRadius = 10
        
        let check = reversed_info_array[indexPath.row] as! NSDictionary
        let check_id = check["id"] as! Int
        let code = check["code"] as! String
        
        if let history = check["history"] as? NSDictionary {
            
            let checkName = history["code"] as! String
            let company = history["company"] as! NSDictionary
            let companyName = company["company_name"] as! String
            cell.buyerCompanyNameLabel.text = companyName
        }
        
        else {
            
            let company = check["company"] as! NSDictionary
            let company_name = company["company_name"] as! String
            cell.buyerCompanyNameLabel.text = company_name
        }
        
        let date = check["add_time"] as! String
        let sum = check["fac_money"] as! Int
        
        cell.checkNameLabel.text = code
        cell.dateLabel.text = date
        cell.cashLabel.text = "\(sum)"
        cell.imageView.image = UIImage(named: "img1")
        
        return cell
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { action, indexPath in
            
            let check = self.reversed_info_array[indexPath.row] as! NSDictionary
            let check_id = check["id"] as! Int
//            debug_print(message: "here is a check id", object: check_id)
            
            self.delete_check_Api(checId: check_id)
            self.collectionView.reloadData()
           }
        
        
        return [deleteAction]
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let check = reversed_info_array[indexPath.row] as! NSDictionary
        let check_id = check["id"] as! Int
        
        if let history = check["history"] as? NSDictionary {
            let history_id = history["id"] as! Int
            
            self.idOfHistory = history_id
        }
        
        self.idOfCheck = check_id
        
        performSegue(withIdentifier: "incomCell", sender: self)
     
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "incomCell" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? IncomeKassaHistoryItem {
                targetController.history_id = idOfHistory
                targetController.id_of_check = idOfCheck
            }
        }
    }

}

extension SecondPage {
    
    func get_CheckList_Api() {
        
                do {
                    reacibility = try Reachability.init()
                    
                }
                catch {
                    
                }
                if ((reacibility!.connection) != .unavailable){
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
                    let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
                    
                    let headers: HTTPHeaders = [
                        "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                        "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                    ]
                    
                    let encodeURL = sellingKassaUrl
                    
                    let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                    
                    requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                        
        //                print(response.request)
        //                print(response.result)
        //                print(response.response)
                        
                        switch response.result {

                        case .success(let payload):
                            MBProgressHUD.hide(for: self.view, animated: true)

                            if let x = payload as? Dictionary<String,AnyObject> {
                                print(x)
                                //let resultValue = x as NSMutableArray
                                //categoryInfo = NSMutableArray(array: resultValue) as! NSArray

                            }

                            else {
                                let resultValue = payload as! NSArray
                                //print("осы жерде категори инфо")
                                //    print(resultValue)

                                self.info_array = NSMutableArray(array: resultValue)
                                self.reversed_info_array = self.info_array.reversed() as NSArray
                                
                                self.collectionView.reloadData()
                                
//                                print("here is a: \(self.reversed_info_array)")
//                                let last_element = self.reversed_history_list[0] as! NSDictionary
//
//                                self.checkName = last_element["history_name"] as! String
//                                self.historyId = last_element["id"] as! Int
//                                self.date = last_element["add_time"] as! String
//                                self.factSum = last_element["sum"] as! Int
//
//                                let company = last_element["company"] as! NSDictionary
//
//                                self.companyName = company["company_name"] as! String

                              
                                
    //                            print("here is the \(self.reversed_history_list)")
    //                            print("here os the first elemtn \(self.reversed_history_list[0])")
                            }
                        case .failure(let error):
                            print(error)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")

                        }

                    })
                    
                }
                else {
                    //print("internet is not working")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                    
                }
                
            }
    
    func delete_check_Api(checId: Int) {
            
                    do {
                        reacibility = try Reachability.init()
                        
                    }
                    catch {
                        
                    }
                    if ((reacibility!.connection) != .unavailable){
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        
                        //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
                        let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
                        
                        let headers: HTTPHeaders = [
                            "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                            "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                        ]
                        
                        let encodeURL = sellingKassaUrl
                        
                        let requestOfApi = AF.request(encodeURL+"\(checId)/", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                        
                        requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                            
                            self.collectionView.reloadData()
                            
                            print(response.request)
                            print(response.result)
                            print(response.response)
                            
                            switch response.result {

                            case .success(let payload):
                                MBProgressHUD.hide(for: self.view, animated: true)

                                if let x = payload as? Dictionary<String,AnyObject> {
//                                    print(x)
                                    

                                }

                                else {
                                    
//                                    let resultValue = payload as! NSArray
                                    
                                }
                            case .failure(let error):
                                print(error)
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")

                            }

                        })
                        
                    }
                    else {
                        //print("internet is not working")
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                        
                    }
                    
                }
}



extension SecondPage {
    
    func ShowErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in}
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
