//
//  MovementProductListVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class MovementProductListVC: DefaultVC, UICollectionViewDataSource, UICollectionViewDelegate  {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [StoreProduct]()
    var categoryID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProds()
    }
    
    private func getProds() {
        ProductNetworkManager.service.getExactCatProds(catId: categoryID) { (products, error) in
            self.products = products ?? [StoreProduct]()
            self.collectionView.reloadData()
        }
    }
    
    private func createCartObject(prodId: Int, amount: Int) {
        MovementNetworkManager.service.createNewCartObject { (message, error) in
            self.addProdToCart(prodId: prodId, amount: amount)
        }
    }
    
    private func addProdToCart(prodId: Int, amount: Int) {
        MovementNetworkManager.service.addProdToCart(addingProd: AddingMovementProd(product_id: prodId, amount: amount)) { (message, error) in
            if message?.message == "exist" {
                self.showSimpleAlert(message: "Продукт уже добавлен в корзину!!!")
            }
            if message?.message == "added" {
                self.navigateToMain()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buygoodCell", for: indexPath) as! BuyProductAddGoodCell
        self.setupCell(cell: cell)
        
        let storeProd = products[indexPath.row]
        let product = storeProd.product
        
        cell.nameLabel.text = product?.productName
        cell.balanceLabel.text = "\(storeProd.amount ?? 0)"
        cell.cashLabel.text = ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storeProd = products[indexPath.row]
        guard let prodId = storeProd.id else {
            return
        }
        showAlertControllerWithTwoTextFields(productId: prodId)
    }
    
    private func navigateBack() {
        performSegue(withIdentifier: "fromMPLtoMFC", sender: self)
    }
    
    private func navigateToMain() {
        performSegue(withIdentifier: "fromMPLtoMM", sender: self)
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
    
    func showAlertControllerWithTwoTextFields(productId: Int) {
        var amount = 1
        
        let alertController = UIAlertController(title: "", message: "Введите количество...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            if alertController.textFields?[0].text != "" {
                let amountString = alertController.textFields?[0].text as! String
                amount = Int(amountString)!
            }
            
            self.createCartObject(prodId: productId, amount: amount)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
        
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "1"
            textfield.keyboardType = .numberPad
        
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
