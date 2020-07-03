//
//  NewImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 6/30/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class NewImportVC: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var contragentNameButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var reachability: Reachability?
    var productArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        
         cardView.layer.cornerRadius = 10
         cardView.dropShadow()
         cardView.layer.backgroundColor = UIColor.white.cgColor

         buyButton.layer.cornerRadius = 15
         buyButton.dropShadowforButton()
         
         cancelButton.layer.cornerRadius = 15
         cancelButton.dropShadowforButton()
         
         contragentNameButton.layer.cornerRadius = 10
         contragentNameButton.dropShadowforButton()

        
    }
    
    private func updateUI() {
        
        self.getProductList()
    }
    
    @IBAction func tappedContragentNameButton(_ sender: Any) {
        
    }
    
    @IBAction func tappedBuyButton(_ sender: Any) {
        
    }
    @IBAction func tappedCancelButton(_ sender: Any) {
        
    }
    

    
}

//MARK: - CollectionView workflow
extension NewImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buyProduct", for: indexPath) as! NewImportCell
        
        let singleProduct = productArray[indexPath.row] as! NSDictionary
        let firstGoods = singleProduct["goods"] as! NSDictionary
        let product = firstGoods["goods"] as! NSDictionary
        
        let productName = product["name"] as! String
        let productRemainedCount = firstGoods["nums"] as! Int
        let productPrice = firstGoods["import_price"] as! Int
        let productCountInCart = singleProduct["nums"] as! Int
        let productTotalPrice = productPrice * productCountInCart
        
        let productIdInCart = singleProduct["id"] as! Int
        
        if product["goods_image"] != nil {
            
            let productImageUrl = product["goods_image"] as! String
            
            cell.productImageView.sd_setImage(with: URL(string: productImageUrl), placeholderImage: UIImage(named: "img1"))
        
        }
        
        cell.productID = productIdInCart
        cell.delegate = self
        
        cell.productNameLabel.text = productName
        cell.remainedCountLabel.text = "\(productRemainedCount)"
        cell.priceLabel.text = "\(productPrice) тг"
        cell.amountLabel.text = "\(productCountInCart)"
        cell.totalPriceLabel.text = "\(productTotalPrice) тг"
        
//        print("products: \(singleProduct)")
        
        return cell
    }
}

extension NewImportVC {
    
     func getProductList() {
        
        do {
            
            self.reachability = try Reachability.init()
        
        }
        
        catch {
            
//            print("unable to start notifier")
        }
        
        if ((reacibility?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                
            ]
            
            let encodeURL = importShoppingCartURL
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request)
//                print(response.result)
//                print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                        
//                        print(x)
//
//                        let resultValue = x as NSMutableArray
//                        categoryInfo = NSMutableArray(array: resultValue) as! NSArray
                    
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        
//                        print("осы жерде категори инфо")
//                        print(resultValue)
                        
                        self.productArray = resultValue
                        self.collectionView.reloadData()
                        
//                        print("here is a \(goodsInBasket.reversed())")
//                        print("осы жерде категори инфо")
//                        print(categoryInfo)
                    
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
    
    func deleteProductFromCart(productID: Int) {
        
        do {
            
            self.reachability = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        }
        
        if ((reacibility?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = importShoppingCartURL + "\(productID)/"
            
            let requestOfApi = AF.request(encodeURL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.updateUI()
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
            
            })
        
        }
        
        else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }

}

extension NewImportVC: NewImportCellDelegate {
    
    func deleteProduct(cell: NewImportCell, id: Int) {
        
//        print("tapped product id: \(id)")
        self.deleteProductFromCart(productID: id)
    }
}

extension NewImportVC {
    
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
