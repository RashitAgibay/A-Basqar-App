//
//  FirstLevelCatExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class FirstLevelCatExportVC: DefaultVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryID = Int()
    var cats = [FirstLevelCat]()
    
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

extension FirstLevelCatExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "firstLevelCatExportCell", for: indexPath) as! FirstLevelCatExportCell
        
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

extension FirstLevelCatExportVC {
    private func navigateToProductList() {
        performSegue(withIdentifier: "fromFLCEtoPLE", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFLCEtoPLE" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? ProductListExportVC {
                destVC.categoryID = self.categoryID
            }
        }
    }
}
