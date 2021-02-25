//
//  NewMovement.swift
//  A-Basqar
//
//  Created by iliyas on 20.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class NewMovementVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomCardView: UIView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var movementPlaceButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var cartProds = [MovementCartProd]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCurrentCart()
    }
    
    @IBAction func tapMovemnetPlaceButton(_ sender: Any) {
        performSegue(withIdentifier: "fromNewMovemnetToSelectPlace", sender: self)
    }
    
    @IBAction func tapSendButton(_ sender: Any) {
        
    }
    @IBAction func tapCancelButton(_ sender: Any) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartProds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buyProduct", for: indexPath)  as! BuyProductFirstPageCell
        self.setupCell(cell: cell)
        cell.delegate = self
        
        let currentProd = cartProds[indexPath.row]
                
        cell.idOfGood = currentProd.id
        cell.nameOfProduct.text = currentProd.product?.product?.productName
        cell.balanceText.text = "\(currentProd.product?.amount ?? 0)"
        cell.amountLabel.text = "В корзине: \(currentProd.amount ?? 0)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentProd = cartProds[indexPath.row]
        guard let prodId = currentProd.id else {
            return
        }
        showAlertControllerWithTwoTextFields(productId: prodId)
    }
    private func setupUI() {
        bottomCardView.layer.cornerRadius = 10
        bottomCardView.dropShadow()
        bottomCardView.layer.backgroundColor = UIColor.white.cgColor
        sendButton.layer.cornerRadius = 10
        sendButton.dropShadowforButton()
        cancelButton.layer.cornerRadius = 10
        cancelButton.dropShadowforButton()
        movementPlaceButton.layer.cornerRadius = 10
        movementPlaceButton.dropShadowforButton()
    }
    
    private func setupCell(cell: BuyProductFirstPageCell) {
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.cellImageView.layer.cornerRadius = 10
    }
    
    private func getCurrentCart() {
        MovementNetworkManager.service.getCurrentCart { (cart, error) in
            self.cartProds = cart?.movementProds ?? [MovementCartProd]()
            self.collectionView.reloadData()
        }
    }
    
    private func editProdAmount(prodId: Int, amount: Int) {
        MovementNetworkManager.service.editCartProdCount(editingCartProd: EditingMovementProd(prodId: prodId, amount: amount)) { (message, error) in
            self.getCurrentCart()
        }
    }
    
    private func deleteCartAmount(prodId: Int) {
        MovementNetworkManager.service.deleteCardProd(deletingProd: DeletingMovementProd(prodId: prodId)) { (message, error) in
            if message?.message == "deleted" {
                self.getCurrentCart()
            }
        }
    }
    
    func showAlertControllerWithTwoTextFields(productId: Int) {
        var amount = 1
        
        let alertController = UIAlertController(title: "", message: "Введите количество...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Изменить", style: .default) { (action) in
            
            if alertController.textFields?[0].text != "" {
                let amountString = alertController.textFields?[0].text as! String
                amount = Int(amountString)!
            }
            
            self.editProdAmount(prodId: productId, amount: amount)
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

extension NewMovementVC: BuyingGoodsCellDelegate {
    func didTappedBuyingDeleteButton(buyingProdsCell: BuyProductFirstPageCell, id: Int) {
        deleteCartAmount(prodId: id)
    }
}
