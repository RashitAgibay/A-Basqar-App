//
//  ProductListVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/2/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class ProductListImportVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func tappedBackButton(_ sender: Any) {
        
        self.navigateToFirstLevelCat()
    }
    

}

extension ProductListImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buygoodCell", for: indexPath)
        
        return cell
    }
    
    
}

extension ProductListImportVC {
    
    private func navigateToFirstLevelCat() {
        
        performSegue(withIdentifier: "fromProdListToFirstLevelCat", sender: self)
    }
}



