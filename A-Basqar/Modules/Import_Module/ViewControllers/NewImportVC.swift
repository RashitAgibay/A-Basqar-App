//
//  NewImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 6/30/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class NewImportVC: DefaultVC {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var contragentNameButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var apiManager = ImportNetworkManager()
    var productList = [ImportCartProduct]()
    var productArray = NSArray()
    var totalSum = Int()
    var selectedProdImportPrice = Int()
    var selectedProdAmount = Int()
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
    }()

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

         collectionView.refreshControl = refreshControl
        
    }
    
    private func updateUI() {
//        self.getCurrentContr()
//        self.getProductList()
        getCurrentImportObject()
    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        
        self.updateUI()
        sender.endRefreshing()
    
    }
    
    @IBAction func tappedContragentNameButton(_ sender: Any) {
        
    }
    
    @IBAction func tappedBuyButton(_ sender: Any) {
        
        if totalSumLabel.text == "0 тг" {
            
            showErrorsAlertWithOneCancelButton(message: "Корзина пуста")
        }
        
        else {
            
            var contrID = self.getCurrentContrID()
//            self.createNewHistory(contrID: contrID, totalSum: self.totalSum)
            self.updateUI()
            
            self.navigateFromNewImportToKassa()
        }
        
        
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        
    }
    
    private func getCurrentImportObject() {
        apiManager.getCurrentCart { (importCart, error) in
            self.productList = importCart?.cartProduct ?? []
            self.collectionView.reloadData()
//            print("/// importCart:", importCart)
//            print("/// error:", error)x
        }
    }
    
    private func editPrices(prodId: Int, importProdId:Int, amount: Int, editingPrices: EditingProductPrices) {
        ProductNetworkManager.service.editPrices(prodId: prodId, editingPrices: editingPrices) { (message, error) in
            if message?.status == "success" {
                print("/// message editPrices:", message)
                self.editProdCount(importProdId: importProdId, amount: amount)
            }
        }
    }
    
    private func editProdCount(importProdId: Int, amount: Int) {
        ImportNetworkManager.service.editProdAmount(editImportProd: EditingImportProd(product_id: importProdId, amount: amount)) { (message, error) in
            if message?.message == "edited" {
                print("/// message editProdCount:", message)
//                self.collectionView.reloadData()
            }
        }
    }

    
    
}

//MARK: - CollectionView workflow
extension NewImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buyProduct", for: indexPath) as! NewImportCell
        cell.delegate = self

        let currentProduct = productList[indexPath.row]

        cell.productID = currentProduct.productId
        cell.productNameLabel.text = currentProduct.importProduct?.product?.productName
        cell.remainedCountLabel.text = "\(currentProduct.importProduct?.amount ?? 0)"
        cell.priceLabel.text = "\(currentProduct.importProduct?.product?.productImportPrice ?? 0) тг"
        cell.amountLabel.text = "\(currentProduct.amount ?? 0)"
        
        cell.totalPriceLabel.text = "\(calculateTotalSum(importProduct: currentProduct)) тг"
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentProd = productList[indexPath.row]
        selectedProdImportPrice = currentProd.importProduct?.product?.productImportPrice ?? Int()
        selectedProdAmount = currentProd.amount ?? Int()
        showAlertControllerWithTwoTextFields(productId: (currentProd.importProduct?.product?.productId)!, companyProdId: currentProd.productId!)
        
    }
}

extension NewImportVC: NewImportCellDelegate {
    
    func deleteProduct(cell: NewImportCell, id: Int) {
        
//        self.deleteProductFromCart(productID: id)
    }
}

extension NewImportVC {
    private func navigateFromNewImportToKassa() {
        performSegue(withIdentifier: "fromNewImportToKassa", sender: self)
    }
}

extension NewImportVC {
    
    func showAlertControllerWithTwoTextFields(productId: Int, companyProdId: Int) {
        
        print("/// productId:", productId)
        print("/// companyProdId:", companyProdId)
        print("/// selectedProdImportPrice", selectedProdImportPrice)
        print("/// selectedProdAmount", selectedProdAmount)
        
//
        let alertController = UIAlertController(title: "", message: "Введите количество и цену...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Изменить", style: .default) { (action) in

            if alertController.textFields?[0].text != "" {
                let amountString = alertController.textFields?[0].text as! String
                self.selectedProdAmount = Int(amountString)!
            }
            if alertController.textFields?[1].text != "" {
                let cashString = alertController.textFields?[1].text as! String
                self.selectedProdImportPrice = Int(cashString)!
            }

            self.editPrices(prodId: productId, importProdId: companyProdId, amount: self.selectedProdAmount, editingPrices: EditingProductPrices(importPrice: self.selectedProdImportPrice))
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in

        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "\(self.selectedProdAmount)"
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


extension NewImportVC {
    
    private func calculateTotalSum(importProduct: ImportCartProduct) -> Int {
        var totalSum = Int()
        
        totalSum = (importProduct.importProduct?.product?.productImportPrice ?? 0) * (importProduct.amount ?? 0)
        
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




