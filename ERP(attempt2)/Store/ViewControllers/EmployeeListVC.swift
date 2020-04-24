//
//  EmployeeListVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class EmployeeListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, StoreCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath)  as! StoreCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tapEditButton(cell: StoreCell, id: Int) {
        
        self.navigateToEditEmployeeData()
    }
    
    private func navigateToEditEmployeeData() {
        
        performSegue(withIdentifier: "fromELtoEED", sender: self)
    }

}
