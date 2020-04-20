//
//  MovementFirstCategoryVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MovementFirstCategoryVC: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "addProd", for: indexPath)  as! AddProdInBuyProdCell
        
        self.setupCell(cell: cell)
        
        
        return cell
    }
    

    private func setupCell(cell: AddProdInBuyProdCell) {
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
    }

}
