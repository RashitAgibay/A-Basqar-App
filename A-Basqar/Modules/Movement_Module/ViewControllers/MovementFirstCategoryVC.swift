//
//  MovementFirstCategoryVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class MovementFirstCategoryVC: DefaultVC {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryArray = NSArray()
    var categoryID = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.getCatList()
    }
    
    
}

extension MovementFirstCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "addProd", for: indexPath) as! FirstLevelCatImportCell
        
        let singleCat = self.categoryArray[indexPath.row] as! NSDictionary
        let category = singleCat["category"] as! NSDictionary
                
        let catName = category["name"] as! String
        cell.catNameLabel.text = catName

        if category["goods_cat_image"] != nil {
            
            let catImageUrl = category["goods_cat_image"] as! String
            
            cell.catImageView.sd_setImage(with: URL(string: catImageUrl), placeholderImage: UIImage(named: "img1"))
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleCat = self.categoryArray[indexPath.row] as! NSDictionary
        let category = singleCat["category"] as! NSDictionary
        let categoryID = category["id"] as! Int
        
        self.categoryID = categoryID
        
        self.navigateToProductList()
    }
    
}

extension MovementFirstCategoryVC {
    
    private func navigateToProductList() {
        
        performSegue(withIdentifier: "fromFirstLevelCatToProdList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromFirstLevelCatToProdList" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? ProductListImportVC {
                destVC.categoryID = self.categoryID
            }
        }
    }
}

extension MovementFirstCategoryVC {
    
    private func getCatList() {
        
        do {
            
            self.reachability = try Reachability.init()
        
        }
        
        catch {
        
        }
        
        if ((reachability?.connection) != .unavailable){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            

            
            let encodeURL = firstLevelCategoryListUrl
            
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print("///", response.result)
//                print("///", response.response)
//                print("///", response.request)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {

                        
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        
                        self.categoryArray = resultValue
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
            
            //print("internet is not working")
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
                       

    }
}
