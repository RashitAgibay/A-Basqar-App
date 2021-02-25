//
//  BidProductListVC.swift
//  A-Basqar
//
//  Created by iliyas on 22.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class BidProductListVC: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reachability: Reachability?
    var userToken = "userToken"
    
//    var productList: Array = [MovementProduct]()
    var categoryID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if categoryID != nil {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buygoodCell", for: indexPath) as! BuyProductAddGoodCell
        self.setupCell(cell: cell)
        
//        let singleProduct = productList[indexPath.row]
//
//        if productList.count != 0 {
//
//            cell.nameLabel.text = singleProduct.productName
//            cell.balanceLabel.text = "\(singleProduct.productCount)"
//            cell.cashLabel.text = "\(singleProduct.productPrice) тенге"
//            cell.googImageView.sd_setImage(with: URL(string: singleProduct.productImageURL), placeholderImage: UIImage(named: "img1"))
//        }
        
        return cell
    }
    
    private func navigateBack() {
        performSegue(withIdentifier: "fromBPLtoBFC", sender: self)
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
    
    
    
    func ShowErrorsAlertWithOneCancelButton(message: String) {
        
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
        
        }
        
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }
}


