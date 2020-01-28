//
//  AddProdInBuyProdCell.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/2/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddProdInBuyProdCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBAction func tappedPlusButton(_ sender: Any) {
        print("tapped plus button in AddProdInBuyProdCell ")
    }
}
