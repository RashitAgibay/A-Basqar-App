//
//  BuyProductFirstPageCell.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/26/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

//MARK: - Cell ішіндегі кнопканы басу үшін
protocol BuyingGoodsCellDelegate {
      func didTappedBuyingDeleteButton(buyingProdsCell: BuyProductFirstPageCell, id: Int)
  }

class BuyProductFirstPageCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameOfProduct: UILabel!
    @IBOutlet weak var balanceText: UILabel!
    @IBOutlet weak var pricesCard: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalPriceText: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var delegate: BuyingGoodsCellDelegate?
    var idOfGood: Int?
    
    @IBAction func deleteButton(_ sender: UIButton) {
        delegate?.didTappedBuyingDeleteButton(buyingProdsCell: self, id: idOfGood!)
    }
}
