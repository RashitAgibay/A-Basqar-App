//
//  SellingProdsCell.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

protocol SellingGoodsCellDelegate {
    func didTappedSellingDeleteButton(sellingProdsCell: SellingProdsCell, id: Int)
}


class SellingProdsCell: UICollectionViewCell {
    @IBOutlet weak var sellingProdImage: UIImageView!
    @IBOutlet weak var sellingProdName: UILabel!
    @IBOutlet weak var sellingProdBalanace: UILabel!
    @IBOutlet weak var sellingProdPriceCard: UIView!
    @IBOutlet weak var sellingProdPrice: UILabel!
    @IBOutlet weak var sellingProdAmount: UILabel!
    @IBOutlet weak var sellingProdTotalPrice: UILabel!
    @IBOutlet weak var sellingDeleteButton: UIButton!
    
    var delegate: SellingGoodsCellDelegate?
    var idOfGood: Int?
    
 
    @IBAction func tapSellingDeleteButton(_ sender: UIButton) {
        delegate?.didTappedSellingDeleteButton(sellingProdsCell: self, id: idOfGood!)
    }
    
    
}
