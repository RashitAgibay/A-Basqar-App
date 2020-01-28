//
//  AddProductsInBuyProductsVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/2/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddProductsInBuyProductsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "userToken"
    var categoryID: Int = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        CategoryApi()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return categoryInfo.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addProd", for: indexPath) as! AddProdInBuyProdCell
        
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.imageView.layer.cornerRadius = 10
        
        
        let dict  = categoryInfo[indexPath.row] as! NSDictionary
        let eachCategory = dict["category"] as! NSDictionary
        
        
        let catName = eachCategory["name"] as? String
        
       
        
        if catName != "" {
            cell.categoryName.text = catName as! String
        }
        
        let imageUrl = eachCategory["goods_cat_image"] as! String

        cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "img1"))
        
        
//        cell.categoryName.text = "some"
//        cell.imageView.image = UIImage(named: "img1")
       
        return  cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let dict  = categoryInfo[indexPath.row] as! NSDictionary
    let eachCategory = dict["category"] as! NSDictionary
    
           let cellCategoryId = eachCategory["id"]

           self.categoryID = cellCategoryId as! Int
    
        //print("here is category id катеригория деген  бетте \(categoryID)")
    
        performSegue(withIdentifier: "fromcategorytogood", sender: self)
    }

    
  //MARK: - Бір беттен екінші бетке қандай да юір ақпарат жіберу үшін.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromcategorytogood" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? BuyProductAddGoodsPageVC {
                targetController.idFromCategory = self.categoryID
            }
        }
    }
    
    func CategoryApi() {
               
               do {
                 self.reacibility = try Reachability.init()
               }
               
               catch {
                // print("unable to start notifier")
                
                
               }
               
        if ((reacibility!.connection) != .unavailable){
                                  MBProgressHUD.showAdded(to: self.view, animated: true)
                   
                //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
                let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
                // print("token is \(token)")
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    //"Authorization":"Token 1d61d12c174b38f660f8026bb3d2cc47b5bec66d".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                    
                   ]
                
                
                
                
                   let encodeURL = categoryUrl
                   
                let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                   
                   requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                       
//                       print(response.request!)
//                       print(response.result)
//                       print(response.response)
                       
                       switch response.result {

                       case .success(let payload):
                           MBProgressHUD.hide(for: self.view, animated: true)

                           if let x = payload as? Dictionary<String,AnyObject> {
                               print(x)

                               //let resultValue = x as NSMutableArray
                            

                            //categoryInfo = NSMutableArray(array: resultValue) as! NSArray
                            
                          

                           }
                        
                           else{
                            let resultValue = payload as! NSArray
                            //print("осы жерде категори инфо")
                            //    print(resultValue)
                            
                            
                            
                            
                            categoryInfo = NSMutableArray(array: resultValue)
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
               
               else{
                   //print("internet is not working")
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
