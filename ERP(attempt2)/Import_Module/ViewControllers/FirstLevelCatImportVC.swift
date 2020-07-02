//
//  FirstLevelCatVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/2/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class FirstLevelCatImportVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
}

extension FirstLevelCatImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "addProd", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.navigateToProductList()
    }
    
}

extension FirstLevelCatImportVC {
    
    private func navigateToProductList() {
        
        performSegue(withIdentifier: "fromFirstLevelCatToProdList", sender: self)
    }
}
