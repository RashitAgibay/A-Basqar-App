//
//  AddNewProductVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/25/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddNewProductVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CaterogyCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        cell.caregoryImage.layer.cornerRadius = 10
        
        cell.categoryName.text = "some text"
        cell.caregoryImage.image = UIImage(named: "img1")
        
        
        
        
        
        return cell
    }
    
    //MARK: - Бір ұяшық басылған кезде болатын іс-әрекет
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
           performSegue(withIdentifier: "intoTheCategory", sender: self)
        
       }
    
    
    

}
