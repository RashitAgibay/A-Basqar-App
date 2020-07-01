//
//  NewImportCell.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 6/30/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class NewImportCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var remainedCountLabel: UILabel!
    @IBOutlet weak var priceCardView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        
        self.contentView.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        
        self.priceCardView.layer.cornerRadius=10
        self.priceCardView.layer.backgroundColor = UIColor.white.cgColor
        self.priceCardView.layer.borderWidth = 1
        self.priceCardView.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        self.productImageView.layer.cornerRadius = 10
        
        
    }
}
