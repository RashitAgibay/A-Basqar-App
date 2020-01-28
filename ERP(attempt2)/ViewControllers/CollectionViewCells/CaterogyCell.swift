//
//  CaterogyCell.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/25/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class CaterogyCell: UICollectionViewCell {
    @IBOutlet weak var caregoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBAction func tapPlusButton(_ sender: Any) {
        print("tapped + button")
    }
}
