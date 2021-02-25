//
//  MovementFirstCategoryVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class MovementFirstCategoryVC: DefaultVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var cats = [FirstLevelCat]()
    var categoryID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCats()
    }
    
    private func getCats() {
        ProductNetworkManager.service.getFirstLevelCats { (categories, error) in
            self.cats = categories ?? [FirstLevelCat]()
            self.collectionView.reloadData()
        }
    }
}

extension MovementFirstCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "addProd", for: indexPath) as! FirstLevelCatImportCell
        
        let currentCat = cats[indexPath.row]
        cell.catNameLabel.text = currentCat.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCat = cats[indexPath.row]
        self.categoryID = currentCat.id!
        self.navigateToProductList()
    }
}

extension MovementFirstCategoryVC {
    
    private func navigateToProductList() {
        performSegue(withIdentifier: "fromFirstLevelCatToProdList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFirstLevelCatToProdList" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? ProductListImportVC {
                destVC.categoryID = self.categoryID
            }
        }
    }
}
