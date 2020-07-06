//
//  ContragentListCell.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/4/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

protocol ContragentListImportCellDelegate {
    
    func updateContragent(cell: ContragentListImportCell, id: Int)
    
}

class ContragentListImportCell: UICollectionViewCell {
    
    @IBOutlet weak var contragentNameLabel: UILabel!
    
    var delegate: ContragentListImportCellDelegate?
    var productID: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    @IBAction func tappedEditButton(_ sender: UIButton) {
        
        delegate?.updateContragent(cell: self, id: productID!)

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
