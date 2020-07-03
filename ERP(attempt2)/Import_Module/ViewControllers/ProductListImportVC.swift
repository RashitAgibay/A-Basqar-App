//
//  ProductListVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/2/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class ProductListImportVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reachability: Reachability?
    var productArray = NSArray()
    var categoryID = Int()
//    var productImportPrice = Int()
//    var productExportPrice = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getProductList()
    }
    

    @IBAction func tappedBackButton(_ sender: Any) {
        
        self.navigateToFirstLevelCat()
    }
    

}

extension ProductListImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buygoodCell", for: indexPath) as! ProductListImportCell
        
        let singleProduct = productArray[indexPath.row] as! NSDictionary
        let product = singleProduct["goods"] as! NSDictionary
        
        let importPrice = singleProduct["import_price"] as! Int
        let exportPrice = singleProduct["export_price"] as! Int
        let productRemainedCount = singleProduct["nums"] as! Int
        
        let productName = product["name"] as! String
        
        cell.productNameLabel.text = productName
        cell.remainedCountLabel.text = "\(productRemainedCount)"
        cell.priceLabel.text = "\(importPrice) тг"
        
        if product["goods_image"] != nil {
            
            let productImageUrl = product["goods_image"] as! String
            
            cell.productImageView.sd_setImage(with: URL(string: productImageUrl), placeholderImage: UIImage(named: "img1"))
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleProduct = productArray[indexPath.row] as! NSDictionary
        let product = singleProduct["goods"] as! NSDictionary
        
        let importPrice = singleProduct["import_price"] as! Int
        let exportPrice = singleProduct["export_price"] as! Int
        
        let productId = product["id"] as! Int
        
        self.ShowAlertControllerWithTwoTextFields(importPrice: importPrice, exportPrice: exportPrice, productID: productId)
    }
    
    
}

extension ProductListImportVC {
    
    private func navigateToFirstLevelCat() {
        
        performSegue(withIdentifier: "fromProdListToFirstLevelCat", sender: self)
    }
    
}



extension ProductListImportVC {
    
    private func getProductList() {
        
        do {
            
            self.reachability = try Reachability.init()
        
        }
        
        catch {
        
        }
        
        if ((reacibility?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
//            print("here is a token: \(token)")
//            print("here is a headers: \(headers)")

            
            let encodeURL = productListUrl + "?cat_id=\(self.categoryID)"
            
//            print("here is a url: \(encodeURL)")
            
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {

//                        print("here is a data: \(x)")
                        
                        let data  = x as! NSDictionary
                        self.productArray = data["results"] as! NSArray
                        self.collectionView.reloadData()
//                        print("here is a array data: \(self.productArray)")
                        
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        
//                        self.categoryArray = resultValue
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
            
            //print("internet is not working")
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
                       

    }
    
    private func sendGoodToBasket(productID: Int, amount: String) {
        
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
            
            let params = [
                
                "goods":"\(productID)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "nums":"\(amount)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            
            ]
            
            let encodeURL = importShoppingCartURL
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
            })
        }
        else {
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
}

extension ProductListImportVC {
    
    func ShowAlertControllerWithTwoTextFields(importPrice: Int, exportPrice: Int, productID: Int) {
        
        var amount = "1"
        
        let alertController = UIAlertController(title: "", message: "Введите количество...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            let amountAlertTextField = alertController.textFields?[0].text
            let cashAlertTextField  = alertController.textFields?[1].text
//            self.import_price = cashAlertTextField as! String
            
            if amountAlertTextField != "" {
                
                amount = amountAlertTextField!
            }
            
            self.sendGoodToBasket(productID: productID, amount: amount)
            
//            self.cashFromAlert = cashAlertTextField
//            self.priceToSendToBuscket = cashAlertTextField as! String
//
//            self.SendGoodToBasketApi()
//            self.SendGoodsPriceToBasketApi()
//            self.goToTheBackPAge()
        
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        
        }
        
        alertController.addTextField { (textfield) in
            
            textfield.placeholder = "1"
            textfield.keyboardType = .numberPad
        
        }
        
        alertController.addTextField { (textfield) in
            
            textfield.placeholder = "\(importPrice)"
            textfield.keyboardType = .numberPad
        
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
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
