//
//  MovementProductListVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class MovementProductListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [StoreProduct]()
    var categoryID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("/// MovementCatId:", categoryID)
        
        if categoryID != nil {
            getProds()
        }

    }
    
    private func getProds() {
        ProductNetworkManager.service.getExactCatProds(catId: categoryID) { (products, error) in
            self.products = products ?? [StoreProduct]()
            self.collectionView.reloadData()
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
        cell.cashLabel.text = "\(product?.productExportPrice ?? 0) тг"
        
        return cell
    }
    
    private func navigateBack() {
        performSegue(withIdentifier: "fromMPLtoMFC", sender: self)
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
}

class MovementProduct {
    var productID = 0
    var productName = ""
    var productCount = 0
    var productPrice = 0
    var productImageURL = ""
}
