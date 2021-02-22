//
//  StoreEmployeesCell.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

protocol StoreEmployeesCellDelegate {
    
    func tapEditButton(cell: StoreEmployeesCell, id: Int)
    func tapDeleteButton(cell: StoreEmployeesCell, id: Int)
}

class StoreEmployeesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: StoreEmployeesCellDelegate?
    var employeeID = Int()
    
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
        
        self.imageView.layer.cornerRadius = 30
//        self.editButton.layer.cornerRadius = 10
        
        
    }
    
    
    
    @IBAction func tapEditButton(_ sender: Any) {
        
        delegate?.tapEditButton(cell: self, id: employeeID)
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        
        delegate?.tapDeleteButton(cell: self, id: employeeID)
    }
    
}
