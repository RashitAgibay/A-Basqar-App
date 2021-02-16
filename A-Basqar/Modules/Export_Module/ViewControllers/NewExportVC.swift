//
//  NewExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class NewExportVC: DefaultVC {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var contragentNameButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var productList = [ExportCartProduct]()
    var totalSum = Int()
    var selectedProdExportPrice = Int()
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
        getCurrentExportObject()
        getCurrentContr()
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
            makeHistory(contr: contrID, cash: "\(totalSum)")
            self.updateUI()
        }
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        
    }
    
    private func getCurrentExportObject() {
        ExportNetworkManager.service.getCurrentCart { (exportCart, error) in
            self.productList = exportCart?.cartProduct ?? []
            self.getProdsFinalCash(products: exportCart?.cartProduct ?? [])
            self.collectionView.reloadData()
        }
    }
    
    private func editPrices(prodId: Int, exportProdId:Int, amount: Int, editingPrices: EditingProductPrices) {
        ProductNetworkManager.service.editPrices(prodId: prodId, editingPrices: editingPrices) { (message, error) in
            if message?.status == "success" {
                self.editProdCount(exportProdId: exportProdId, amount: amount)
            }
        }
    }
    
    private func editProdCount(exportProdId: Int, amount: Int) {
        ExportNetworkManager.service.editProdAmount(editExportProd: EditingExportProd(product_id: exportProdId, amount: amount)) { (message, error) in
            if message?.message == "edited" {
                self.getCurrentExportObject()
            }
        }
    }
    
    private func deleteProd(deletingProdId: Int) {
        ExportNetworkManager.service.deleteProdInCart(deletingProdId: deletingProdId) { (message, error) in
            if message?.message == "deleted" {
                self.getCurrentExportObject()
            }
        }
    }
    
    private func makeHistory(contr: Int, cash: String) {
        ExportNetworkManager.service.makeHistory(cartObject: ExportCartModel(contragent_id: contr, cash: cash)) { (message, error) in
            if message?.message == "success" {
                self.navigateFromNewExportToKassa()
            }
        }
    }
}

//MARK: - CollectionView workflow
extension NewExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "newExportCell", for: indexPath) as! NewExportCell
        cell.delegate = self
        
        let currentProduct = productList[indexPath.row]

        cell.productID = currentProduct.productId
        cell.productNameLabel.text = currentProduct.exportProduct?.product?.productName
        cell.remainedCountLabel.text = "\(currentProduct.exportProduct?.amount ?? 0)"
        cell.priceLabel.text = "\(currentProduct.exportProduct?.product?.productExportPrice ?? 0) тг"
        cell.amountLabel.text = "\(currentProduct.amount ?? 0)"
        cell.totalPriceLabel.text = "\(calculateTotalSum(exportProduct: currentProduct)) тг"
        cell.productID = currentProduct.productId
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentProd = productList[indexPath.row]
        selectedProdExportPrice = currentProd.exportProduct?.product?.productExportPrice ?? Int()
        selectedProdAmount = currentProd.amount ?? Int()
        showAlertControllerWithTwoTextFields(productId: (currentProd.exportProduct?.product?.productId)!, companyProdId: currentProd.productId!)
    }
}

extension NewExportVC: NewExportCellDelegate {
    func deleteProduct(cell: NewExportCell, id: Int) {
        deleteProd(deletingProdId: id)
    }
}

extension NewExportVC {
    private func navigateFromNewExportToKassa() {
        performSegue(withIdentifier: "fromNEtoKE", sender: self)
    }
}

extension NewExportVC {
    func showAlertControllerWithTwoTextFields(productId: Int, companyProdId: Int) {

        let alertController = UIAlertController(title: "", message: "Введите количество и цену...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Изменить", style: .default) { (action) in

            if alertController.textFields?[0].text != "" {
                let amountString = alertController.textFields?[0].text as! String
                self.selectedProdAmount = Int(amountString)!
            }
            if alertController.textFields?[1].text != "" {
                let cashString = alertController.textFields?[1].text as! String
                self.selectedProdExportPrice = Int(cashString)!
            }

            self.editPrices(prodId: productId, exportProdId: companyProdId, amount: self.selectedProdAmount, editingPrices: EditingProductPrices(exportPrice: self.selectedProdExportPrice))
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "\(self.selectedProdAmount)"
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


extension NewExportVC {
    private func calculateTotalSum(exportProduct: ExportCartProduct) -> Int {
        var totalSum = Int()
        totalSum = (exportProduct.exportProduct?.product?.productExportPrice ?? 0) * (exportProduct.amount ?? 0)
        
        return totalSum
    }
    
    private func getProdsFinalCash(products: [ExportCartProduct]) {
        var cash = Int()
        for item in products {
            cash += (item.exportProduct?.product?.productExportPrice ?? 0) * (item.amount ?? 0)
        }
        totalSum = cash
        totalSumLabel.text = "\(cash) тг"
    }
    
    private func getCurrentContrtName() -> String {
        var contrName = String()
        contrName = UserDefaults.standard.string(forKey: selectedExportContr) ?? ""
        
        return contrName
    }
    
    private func getCurrentContrID() -> Int {
        var contrID = Int()
        contrID = UserDefaults.standard.integer(forKey: selectedExportContrID)
        
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




