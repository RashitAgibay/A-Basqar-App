//
//  ContragentListExportListCell.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/27/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class ContragentListExportListCell: UICollectionViewCell {
    
    
    @IBOutlet weak var conrtagentNameLabel: UILabel!
    var contrID: Int?

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
    
    }
}
