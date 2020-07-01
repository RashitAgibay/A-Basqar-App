//
//  NewImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 6/30/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class NewImportVC: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var contragentNameButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        
         cardView.layer.cornerRadius = 10
         cardView.dropShadow()
         cardView.layer.backgroundColor = UIColor.white.cgColor

         buyButton.layer.cornerRadius = 15
         buyButton.dropShadowforButton()
         
         cancelButton.layer.cornerRadius = 15
         cancelButton.dropShadowforButton()
         
         contragentNameButton.layer.cornerRadius = 10
         contragentNameButton.dropShadowforButton()

        
    }
    
    
    @IBAction func tappedContragentNameButton(_ sender: Any) {
        
    }
    
    @IBAction func tappedBuyButton(_ sender: Any) {
        
    }
    @IBAction func tappedCancelButton(_ sender: Any) {
        
    }
    
}

//MARK: - CollectionView workflow
extension NewImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buyProduct", for: indexPath)
        
        return cell
    }
    
    
    
}
