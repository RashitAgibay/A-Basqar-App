//
//  IncomeKassaHistoryListVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 1/23/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class IncomeKassaHistoryListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var historyList: NSArray = []
    var history_ID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getHistoryNamesListApi()
        // Do any additional setup after loading the view.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buyerCell", for: indexPath) as! BuyerCompanyCell
        

        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        let historyDict = historyList[indexPath.row] as! NSDictionary
        let historyName = historyDict["history_name"] as! String
        
        let compaany = historyDict["company"] as! NSDictionary
        let companyName = compaany["company_name"] as! String
        
        let sum = historyDict["sum"] as! Int
        let date = historyDict["add_time"] as! String
        
        
//        cell.BuyerCompanyName.text = historyName
        cell.contragenName.text = "Контрагент: " + companyName
        cell.totalSum.text = "\(sum)-тг"
        cell.date.text = date
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let historyDict = historyList[indexPath.row] as! NSDictionary
        let historyId = historyDict["id"] as! Int

        self.history_ID = historyId
        
        performSegue(withIdentifier: "selecthistorynameitem", sender: self)
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecthistorynameitem" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? IncomeKassaVC {
                targetController.history_id_from_list = history_ID
            }
        }
    }
    
}

extension IncomeKassaHistoryListVC {
    
    func getHistoryNamesListApi() {
        
        do {
            
            reacibility = try Reachability.init()
        }
        
        catch {
            print("unable to start notifier")
        }
        
        if ((reacibility!.connection) != .none){
            
            let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = sellingHistoryUrl
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                               
//                               print(response.request!)
//                               print(response.result)
//                               print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                                    print(x)
                                    //let resultValue = x as NSMutableArray
                                    //categoryInfo = NSMutableArray(array: resultValue) as! NSArray
                    }
                    
                    else {
                        let resultValue = payload as! NSArray
                                    //print("осы жерде категори инфо")
                                    //    print(resultValue)
                        self.historyList = NSArray(array: resultValue)
//                                    print("here is a historyList: \(self.historyList)")
                        self.collectionView.reloadData()
//                                    print("here is a \(goodsInBasket.reversed())")
                                    //print("осы жерде категори инфо")
                                    //print(categoryInfo)
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
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
}


extension IncomeKassaHistoryListVC {
    
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
