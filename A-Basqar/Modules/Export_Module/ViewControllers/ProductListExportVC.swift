//
//  ProductListExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class ProductListExportVC: DefaultVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [StoreProduct]()
    var categoryID = Int()
    var selectedProdExportPrice = Int()
    
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
        ExportNetworkManager.service.createNewCart { (response, error) in
            self.addProductToCart(productId: productId, amount: amount)
            self.editProdPrices(prodId: companyProdId, editingPrices: editingPrices)
        }
    }
    
    private func addProductToCart(productId: Int, amount: Int) {
        ExportNetworkManager.service.addProdsToCart(product: AddingExportProd(product_id: productId, amount: amount)) { (response, error) in
            if response?.message == "exist" {
                self.showSimpleAlert(message: "Продукт уже добавлен в корзину!!!")
            }
            else {
                self.navigateToMainExport()
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

extension ProductListExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "productListExportCell", for: indexPath) as! ProductListExportCell
        
        let storeProd = products[indexPath.row]
        let product = storeProd.product
        
        cell.productNameLabel.text = product?.productName
        cell.remainedCountLabel.text = "\(storeProd.amount ?? 0)"
        cell.priceLabel.text = "\(product?.productExportPrice ?? 0) тг"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storeProd = products[indexPath.row]
        guard let prodId = storeProd.id else {
            return
        }
        selectedProdExportPrice = storeProd.product?.productExportPrice ?? Int()
        showAlertControllerWithTwoTextFields(productId: prodId, companyProdId: (storeProd.product?.productId)!)
    }
}

extension ProductListExportVC {
    private func navigateToMainExport() {
        performSegue(withIdentifier: "fromPLEtoME", sender: self)
    }
    
    private func navigateToFirstLevelCat() {
        performSegue(withIdentifier: "fromPLEtoFLCE", sender: self)
    }
}

extension ProductListExportVC {
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
                self.selectedProdExportPrice = Int(cashString)!
            }
            
            self.createCartObject(productId: productId, companyProdId: companyProdId, amount: amount, editingPrices: EditingProductPrices(exportPrice: self.selectedProdExportPrice))
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "1"
            textfield.keyboardType = .numberPad
        
        }
        alertController.addTextField { (textfield) in

            textfield.placeholder = "\(self.selectedProdExportPrice) тенге"
            textfield.keyboardType = .numberPad

        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
    }
}
