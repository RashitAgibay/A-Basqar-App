//
//  BuyingHistoryVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/2/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit
import SwipeCellKit

var reacibility: Reachability?
var userTokenForUserStandart: String = "userToken"

class BuyingHistoryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SwipeCollectionViewCellDelegate {
    
    
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var historyItem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 

        getHistoryListApi()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buyingHistoryInfo.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! ByuingHistoryViewCell
        
        cell.delegate = self
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.imageVIew.layer.cornerRadius = 10
        
        
        let oneHistory = buyingHistoryInfo[indexPath.row] as! NSDictionary
        
//        print("here is a history list \(buyingHistoryInfo[indexPath.row])")
        
        let historyName = oneHistory["history_name"] as! String
        let totalSum = oneHistory["sum"] as! Int
        let date = oneHistory["add_time"] as! String
        
        let companyInfo = oneHistory["company"] as! NSDictionary
        let companyName = companyInfo["company_name"] as! String
       
//        print("here is a history name: \(historyName)")
//        print("here is a company name: \(companyName)")
//        print("here is a date: \(date)")
//        print("here is a total cash sum: \(totalSum)")
        
        
        
        cell.buyingName.text = historyName
        cell.buyerName.text = companyName
        cell.date.text = date
        cell.price.text = "\(totalSum)"
        cell.imageVIew.image = UIImage(named: "img1")
        
        
        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.cellSwipedToLeft))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        cell.addGestureRecognizer(swipeLeft)
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { action, indexPath in
               
            let dict = buyingHistoryInfo[indexPath.row] as! NSDictionary
            let id = dict["id"] as! Int
            debug_print(message: "here is a history id", object: id)
            
           }
        
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
//    @objc func cellSwipedToLeft(){
//        print("swiped left")
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let oneHistory = buyingHistoryInfo[indexPath.row] as! NSDictionary
        let itemId = oneHistory["id"] as! Int
        historyItem = itemId
//        print(itemId)
        
        performSegue(withIdentifier: "toHistoryItem", sender: self)
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHistoryItem" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? BuyingHistoryItemVC {
                targetController.historyItemID = historyItem
            }
        }
    }
 

}


//MARK: - Api Parts
extension BuyingHistoryVC {

    func getHistoryListApi() {
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
            
            let encodeURL = buyingHistoryUrl
            
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

                        
                        
                        reversedBuyingHistoryInfo = NSMutableArray(array: resultValue)
                        
                        buyingHistoryInfo = reversedBuyingHistoryInfo.reversed() as NSArray
                        self.collectionView.reloadData()

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
            //print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            
        }
        
    }
    
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
