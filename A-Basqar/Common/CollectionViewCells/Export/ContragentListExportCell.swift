//
//  ContragentListExportCell.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/3/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

protocol ContragentListExportCellDelegate {
    
    func tapToUpdateContragent(cell: ContragentListExportCell, id: Int)
    
}

class ContragentListExportCell: UICollectionViewCell {
    
    @IBOutlet weak var contragentNameLabel: UILabel!
    
    var delegate: ContragentListExportCellDelegate?
    var contrID: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    @IBAction func tappedEditButton(_ sender: UIButton) {
        
        delegate?.tapToUpdateContragent(cell: self, id: contrID!)

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
