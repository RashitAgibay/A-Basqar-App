//
//  MovementProductListVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class MovementProductListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reachability: Reachability?
    var userToken = "userToken"
    
    var productList: Array = [MovementProduct]()
    var categoryID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if categoryID != nil {
            getProductsFromApi()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buygoodCell", for: indexPath) as! BuyProductAddGoodCell
        
        self.setupCell(cell: cell)
        
        let singleProduct = productList[indexPath.row]
        
        if productList.count != 0 {
            
            cell.nameLabel.text = singleProduct.productName
            cell.balanceLabel.text = "\(singleProduct.productCount)"
            cell.cashLabel.text = "\(singleProduct.productPrice) тенге"
            cell.googImageView.sd_setImage(with: URL(string: singleProduct.productImageURL), placeholderImage: UIImage(named: "img1"))
        }
        
        return cell
    }
    
    
    private func navigateBack() {
        performSegue(withIdentifier: "fromMPLtoMFC", sender: self)
    }
    
    
    private func setupCell(cell: BuyProductAddGoodCell) {
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.googImageView.layer.cornerRadius = 5
        
    }
    @IBAction func tapBackButton(_ sender: Any) {
        
        navigateBack()
    }
    
    private func getProductsFromApi() {
        
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
            
            let encodeURL = "\(goodListUrl)?cat_id=\(self.categoryID)"
            
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

                        for item in arrayData {
                            
                            let singleProduct = item as! NSDictionary
                            let product = MovementProduct()
                            
                            let goodID = singleProduct["id"] as! Int
                            let productImportPrice = singleProduct["import_price"] as! Int
                            
                            let embededProductsInfo = singleProduct["goods"] as! NSDictionary
                            let productName = embededProductsInfo["name"] as! String
                            let productAmount = singleProduct["nums"] as! Int
                            let categoryDict = embededProductsInfo["category"] as! NSDictionary
                            let categoryID = categoryDict["id"] as! Int
                            let productImageUrl = embededProductsInfo["goods_image"] as! String
                            
                            product.productName = productName
                            product.productCount = productAmount
                            product.productPrice = productImportPrice
                            product.productImageURL = productImageUrl
                            

                            self.productList.append(product)
                            
                        }
                        
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

class MovementProduct {
    
    var productID = 0
    var productName = ""
    var productCount = 0
    var productPrice = 0
    var productImageURL = ""
}
