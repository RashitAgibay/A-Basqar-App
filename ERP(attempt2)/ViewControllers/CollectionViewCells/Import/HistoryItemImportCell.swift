//
//  HistoryItemImportCell.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class HistoryItemImportCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var productTotalPriceLabel: UILabel!
    
    @IBOutlet weak var productAmountCardView: UIView!
    @IBOutlet weak var productTotalPriceCardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        
        self.productAmountCardView.layer.cornerRadius = 10
        self.productAmountCardView.layer.backgroundColor = UIColor.white.cgColor
        self.productAmountCardView.layer.borderWidth = 1
        self.productAmountCardView.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        self.productTotalPriceCardView.layer.cornerRadius = 10
        self.productTotalPriceCardView.layer.backgroundColor = UIColor.white.cgColor
        self.productTotalPriceCardView.layer.borderWidth = 1
        self.productTotalPriceCardView.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        self.productImageView.layer.cornerRadius = 5
        
        
    }
}
