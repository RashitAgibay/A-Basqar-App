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
    var categoryID = Int()
    var selectedProdImportPrice = Int()
    
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
    
    private func createCartObject(productId: Int, companyProdId:Int, amount: Int, editingPrices: EditingProductPrices) {
        ImportNetworkManager.service.createNewCart { (response, error) in
            self.addProductToCart(productId: productId, amount: amount)
            self.editProdPrices(prodId: companyProdId, editingPrices: editingPrices)
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
    
    private func editProdPrices(prodId: Int, editingPrices: EditingProductPrices) {
        ProductNetworkManager.service.editPrices(prodId: prodId, editingPrices: editingPrices) { (message, error) in
            if message?.status == "success" {
                
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
        selectedProdImportPrice = storeProd.product?.productImportPrice ?? Int()
        showAlertControllerWithTwoTextFields(productId: prodId, companyProdId: (storeProd.product?.productId)!)
    }
}

extension ProductListImportVC {
    private func navigateToMainImport() {
        performSegue(withIdentifier: "fromProductListToMainImport", sender: self)
    }
    
    private func navigateToFirstLevelCat() {
        performSegue(withIdentifier: "fromProdListToFirstLevelCat", sender: self)
    }
}

extension ProductListImportVC {
    func showAlertControllerWithTwoTextFields(productId: Int, companyProdId: Int) {
        var amount = 1
        
        let alertController = UIAlertController(title: "", message: "Введите количество...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            if alertController.textFields?[0].text != "" {
                let amountString = alertController.textFields?[0].text as! String
                amount = Int(amountString)!
            }
            if alertController.textFields?[1].text != "" {
                let cashString = alertController.textFields?[1].text as! String
                self.selectedProdImportPrice = Int(cashString)!
            }
            
            self.createCartObject(productId: productId, companyProdId: companyProdId, amount: amount, editingPrices: EditingProductPrices(importPrice: self.selectedProdImportPrice))
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "1"
            textfield.keyboardType = .numberPad
        
        }
        alertController.addTextField { (textfield) in

            textfield.placeholder = "\(self.selectedProdImportPrice) тенге"
            textfield.keyboardType = .numberPad

        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
    }
}
