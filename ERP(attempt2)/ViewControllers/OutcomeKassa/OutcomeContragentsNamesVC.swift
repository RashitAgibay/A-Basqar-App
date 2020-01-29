//
//  OutcomeContragentsNamesVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 1/29/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class OutcomeContragentsNamesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var companyNameInList: String = "Контрагент..."
    var companyId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GetBuyerCompaniesApi()
    }
    

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return buyerListDataInfo.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buyerCell", for: indexPath) as! BuyerCompanyCell
       
       cell.contentView.layer.cornerRadius = 10
       cell.layer.shadowColor = UIColor.gray.cgColor
       cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
       cell.layer.shadowOpacity = 0.5
       cell.layer.masksToBounds = false
       cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
       
       let companiesData = buyerListDataInfo[indexPath.row] as! NSDictionary

       let companyName = companiesData["company_name"] as! String
       

       cell.BuyerCompanyName.text = companyName
       
       
       
       
       
       return cell
   }

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       let companiesData = buyerListDataInfo[indexPath.row] as! NSDictionary
       companyNameInList = companiesData["company_name"] as! String
       companyId = companiesData["id"] as! Int
       
       performSegue(withIdentifier: "totheoutcomepageskassa", sender: self)
        
       }
   
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "totheoutcomepageskassa" {
           if let destVC = segue.destination as? UINavigationController,
               let targetController = destVC.topViewController as? OutcomeKassaVC {
               targetController.company_name = companyNameInList
               targetController.company_id = companyId
           }
       }
   }
    
    
    func GetBuyerCompaniesApi() {
        
        do {
            reacibility = try Reachability.init()
        }
        
        catch {
        
        }
        
        if ((reacibility!.connection) != .unavailable){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            
            let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = buyerCompaniesUrl
            
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                switch response.result {
                
                case .success(let payload):
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                        print(x)
                    
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        
                        buyerListDataInfo = NSMutableArray(array: resultValue)
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


