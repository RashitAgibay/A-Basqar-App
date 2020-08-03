//
//  NewImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 6/30/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class NewImportVC: DefaultVC {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var contragentNameButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var productArray = NSArray()
    var totalSum = Int()
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        updateUI()
        
        collectionView.refreshControl = refreshControl
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
        
        self.getCurrentContr()
        self.getProductList()
        
    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        
        self.updateUI()
        sender.endRefreshing()
    
    }
    
    @IBAction func tappedContragentNameButton(_ sender: Any) {
        
    }
    
    @IBAction func tappedBuyButton(_ sender: Any) {
        
        if totalSumLabel.text == "0 тг" {
            
            ShowErrorsAlertWithOneCancelButton(message: "Корзина пуста")
        }
        
        else {
            
            var contrID = self.getCurrentContrID()
            self.createNewHistory(contrID: contrID, totalSum: self.totalSum)
            self.updateUI()
            
            self.navigateFromNewImportToKassa()
        }
        
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singleProduct = productArray[indexPath.row] as! NSDictionary
        let firstGoods = singleProduct["goods"] as! NSDictionary
        let product = firstGoods["goods"] as! NSDictionary
        
        let productName = product["name"] as! String
        let productImportPrice = firstGoods["import_price"] as! Int
        let productExportPrice = firstGoods["export_price"] as! Int
        let productCountInCart = singleProduct["nums"] as! Int
        let productIdInCart = singleProduct["id"] as! Int
        let productId = firstGoods["id"] as! Int
        
        self.ShowAlertControllerWithTwoTextFields(importPrice: "\(productImportPrice)", exportPrice: "\(productExportPrice)", productCount: productCountInCart,productName: productName, productID: productId, productIdInCart: productIdInCart)
        
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
                                                
                    }
                    
                    else {
                        
                        let resultValue = payload as! NSArray
                        
                        self.productArray = resultValue
                        self.collectionView.reloadData()
                        
                        let totalSum = self.calculateTotalSum(array: self.productArray)
                        self.totalSum  = totalSum
                        self.totalSumLabel.text = "\(totalSum) тг"
                        
                        
                    
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
    
    func editProductPrice(productID: Int, importPrice: String, exportPrice: String) {
        
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
                
                "export_price":exportPrice.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                "import_price":importPrice.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
            ]
            
            let encodeURL = productListUrl + "\(productID)/"
            
            let requestOfApi = AF.request(encodeURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
//                    print(response.request!)
//                    print(response.result)
//                    print(response.response)
                
                })
        
        }
        
        else {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    private func editProductCountIntCart(productIdInCart: Int, productID: Int, amount: String) {
        
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
            
            let encodeURL = importShoppingCartURL + "\(productIdInCart)/"
            
            let requestOfApi = AF.request(encodeURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                
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
    
    private func createNewHistory(contrID: Int, totalSum: Int) {
        
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
                
                "company":contrID,
                "sum":totalSum
            ]
            
            let encodeURL = importHistoryListURL
            
//            print(params)
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in

                MBProgressHUD.hide(for: self.view, animated: true)

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

extension NewImportVC: NewImportCellDelegate {
    
    func deleteProduct(cell: NewImportCell, id: Int) {
        
        self.deleteProductFromCart(productID: id)
    }
}

extension NewImportVC {
    
    private func navigateFromNewImportToKassa() {
        
        performSegue(withIdentifier: "fromNewImportToKassa", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "fromFirstLevelCatToProdList" {
//            if let navigationVC = segue.destination as? UINavigationController,
//                let destVC = navigationVC.topViewController as? ProductListImportVC {
//                destVC.categoryID = self.categoryID
//            }
//        }
//    }
}

extension NewImportVC {
    
    func ShowAlertControllerWithTwoTextFields(importPrice: String, exportPrice: String, productCount: Int, productName: String, productID: Int, productIdInCart: Int) {
        
        var amount = "1"
        
        let alertController = UIAlertController(title: productName, message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Изменить", style: .default) { (action) in
            
            let amountAlertTextField = alertController.textFields?[0].text as! String
            let cashAlertTextField  = alertController.textFields?[1].text as! String
            
            if amountAlertTextField != "" {
                
                self.editProductCountIntCart(productIdInCart: productIdInCart, productID: productID, amount: amountAlertTextField)
            }
            
            if cashAlertTextField != "" {
                
                self.editProductPrice(productID: productID, importPrice: "\(cashAlertTextField)", exportPrice: exportPrice)
                
            }
            
//            self.sendGoodToBasket(productID: productID, amount: amount)
            self.updateUI()
        
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        
        }
        
        alertController.addTextField { (textfield) in
            
            textfield.placeholder = "\(productCount)"
            textfield.keyboardType = .numberPad
        }
        
        alertController.addTextField { (textfield) in
            
            textfield.placeholder = "\(importPrice) тенге"
            textfield.keyboardType = .numberPad
        
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
}


extension NewImportVC {
    
    private func calculateTotalSum(array: NSArray) -> Int {
        
        var totalSum = Int()
        
        for item in array {
            
            let singleProduct = item as! NSDictionary
             
            let firstGoods = singleProduct["goods"] as! NSDictionary
            let product = firstGoods["goods"] as! NSDictionary
            
            let productPrice = firstGoods["import_price"] as! Int
            let productCountInCart = singleProduct["nums"] as! Int
            let productTotalPrice = productPrice * productCountInCart
            
            totalSum += productTotalPrice
        }
        
        return totalSum
    }
    
    private func getCurrentContrtName() -> String {
        
        var contrName = String()
        
        contrName = UserDefaults.standard.string(forKey: selectedImportContr) ?? ""
        
        return contrName
        
    }
    
    private func getCurrentContrID() -> Int {
        
        var contrID = Int()
        
        contrID = UserDefaults.standard.integer(forKey: selectedImportContrID)
        
        return contrID
        
    }
    
    private func getCurrentContr() {
        
        var currentContrName = String()
        var currentContrId = Int()
        
        currentContrName = getCurrentContrtName()
        currentContrId = getCurrentContrID()
        
        if currentContrName == "" {
            
            self.contragentNameButton.setTitle("Выберите...", for: .normal)
        }
        
        else {
            
            self.contragentNameButton.setTitle(currentContrName, for: .normal)
        }
        
    }
    
}




