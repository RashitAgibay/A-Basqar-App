//
//  ProductListVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/2/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class ProductListImportVC: DefaultVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [StoreProduct]()
    var productArray = NSArray()
    var categoryID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProds()
    }
    

    @IBAction func tappedBackButton(_ sender: Any) {
        self.navigateToFirstLevelCat()
    }
    
    private func getProds() {
        ProductNetworkManager.service.getExactCatProds(catId: categoryID) { (products, error) in
            self.products = products ?? [StoreProduct]()
            self.collectionView.reloadData()
        }
    }
    
    private func createCartObject(productId: Int, amount: Int) {
        ImportNetworkManager.service.createNewCart { (response, error) in
            self.addProductToCart(productId: productId, amount: amount)
        }
    }
    
    private func addProductToCart(productId: Int, amount: Int) {
        ImportNetworkManager.service.addProdsToCart(product: AddingImportProd(product_id: productId, amount: amount)) { (response, error) in
            if response?.message == "exist" {
                self.showSimpleAlert(message: "Продукт уже добавлен в корзину!!!")
            }
            else {
                self.navigateToMainImport()
            }
        }
    }
}

extension ProductListImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buygoodCell", for: indexPath) as! ProductListImportCell
        
        let storeProd = products[indexPath.row]
        let product = storeProd.product
        
        cell.productNameLabel.text = product?.productName
        cell.remainedCountLabel.text = "\(storeProd.amount ?? 0)"
        cell.priceLabel.text = "\(product?.productImportPrice ?? 0) тг"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storeProd = products[indexPath.row]
        guard let prodId = storeProd.id else {
            return
        }
        showAlertControllerWithTwoTextFields(productId: prodId)
    }
    
    
}

extension ProductListImportVC {
    private func navigateToFirstLevelCat() {
        performSegue(withIdentifier: "fromProdListToFirstLevelCat", sender: self)
    }
    
}


extension ProductListImportVC {
    private func navigateToMainImport() {
        performSegue(withIdentifier: "fromProductListToMainImport", sender: self)
    }
}

extension ProductListImportVC {
    func showAlertControllerWithTwoTextFields(productId: Int) {
        var amount = 1
        
        let alertController = UIAlertController(title: "", message: "Введите количество...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
//            let cashAlertTextField  = alertController.textFields?[1].text as! String
            if alertController.textFields?[0].text != "" {
                let amountString = alertController.textFields?[0].text as! String
                amount = Int(amountString)!
            }

            self.createCartObject(productId: productId, amount: amount)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "1"
            textfield.keyboardType = .numberPad
        
        }
//        alertController.addTextField { (textfield) in
//
//            textfield.placeholder = "\(importPrice)"
//            textfield.keyboardType = .numberPad
//
//        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
}






