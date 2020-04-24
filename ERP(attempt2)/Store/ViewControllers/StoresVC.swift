//
//  StoresVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class StoresVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, StoreCellDelegate {

    
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath)  as! StoreCell
        
        cell.storeID = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    func tapEditButton(cell: StoreCell, id: Int) {
//        print("test \(id)")
        self.navigateToEditStore()
    }

    private func navigateToEditStore() {
        performSegue(withIdentifier: "fromStoES", sender: self)
    }

}
