//
//  NewBidVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class NewBidVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    

    @IBAction func tapSendButton(_ sender: Any) {
        
    }
    @IBAction func tapCancelButton(_ sender: Any) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buyProduct", for: indexPath)  as! BuyProductFirstPageCell
        
        self.setupCell(cell: cell)
        
        
        return cell
    }
    
    private func setupUI() {
        
        sendButton.layer.cornerRadius = 25
        sendButton.dropShadowforButton()
        
        cancelButton.layer.cornerRadius = 25
        cancelButton.dropShadowforButton()
    }
    
    private func setupCell(cell: BuyProductFirstPageCell) {
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        cell.pricesCard.layer.cornerRadius = 10
        cell.pricesCard.layer.backgroundColor = UIColor.white.cgColor
        cell.pricesCard.layer.borderWidth = 1
        cell.pricesCard.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        cell.cellImageView.layer.cornerRadius = 10
        
    }

}
