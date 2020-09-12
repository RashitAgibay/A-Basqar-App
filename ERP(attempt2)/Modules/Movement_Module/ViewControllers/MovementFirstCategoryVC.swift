//
//  MovementFirstCategoryVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MovementFirstCategoryVC: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reachability: Reachability?
    var userToken = "userToken"
    
    var categoryList = NSArray()
    var categoryID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCategoryListFropApi()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "addProd", for: indexPath)  as! AddProdInBuyProdCell
        
        if categoryList.count != 0 {
            
            let dict = categoryList[indexPath.row] as! NSDictionary
            let eachCategory = dict["category"] as! NSDictionary
            let categoryName = eachCategory["name"] as! String
            let imageUrl = eachCategory["goods_cat_image"] as! String
            
            cell.categoryName.text = categoryName
            cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "img1"))
        }
        

    
        
        
        
        self.setupCell(cell: cell)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = categoryList[indexPath.row] as! NSDictionary
        let eachCategory = dict["category"] as! NSDictionary
        let categoryID = eachCategory["id"]
        
        self.categoryID = categoryID as! Int
        
        self.navgiateToProductList()
    }
    
    private func navgiateToProductList() {
        
        performSegue(withIdentifier: "fromMFCtoMPL", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromMFCtoMPL" {
            
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MovementProductListVC {
                destVC.categoryID = self.categoryID
            }
        }
    }
    
    
    

    private func setupCell(cell: AddProdInBuyProdCell) {
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
    }

    private func getCategoryListFropApi() {
        
        do {
            self.reachability = try Reachability.init()
        }
        
        catch {
            
        }
        
        if ((reachability!.connection) != .unavailable) {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: self.userToken) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = categoryUrl
            
            let request = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            request.responseJSON(completionHandler: { (response) -> Void in
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
                
                switch response.result {
                
                case .success(let json):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let data = json as? NSDictionary {
                        
                        print(data)
                    }
                    
                    else {
                        
                        let arrayData = json as! NSArray
                        self.categoryList = arrayData
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
    
    func ShowErrorsAlertWithOneCancelButton(message: String) {
        
         let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                   let action = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
                       
                   }
                   alertController.addAction(action)
                   self.present(alertController,animated: true, completion: nil)
    }
}


