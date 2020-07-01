//
//  HistoryImportCell.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class HistoryImportCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var importNameLabel: UILabel!
    @IBOutlet weak var conrtagentNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
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
        
        
        self.productImageView.layer.cornerRadius = 10
        
        
    }
}
