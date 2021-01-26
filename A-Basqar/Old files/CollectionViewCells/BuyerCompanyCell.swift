//
//  BuyerCompanyCell.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/2/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class BuyerCompanyCell: UICollectionViewCell {
    
    @IBOutlet weak var BuyerCompanyName: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var contragenName: UILabel!
    @IBOutlet weak var totalSum: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBAction func tappedChangeButton(_ sender: Any) {
        print("tapped change Button from BuyerCompanyCell")
        
        
       // performSegue(withIdentifier: "fromBuyer", sender: self)
    }
}
