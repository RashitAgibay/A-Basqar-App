//
//  StoresVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class StoresVC: DefaultVC, UICollectionViewDataSource, UICollectionViewDelegate, StoreCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var stores = [Store]()
    var storeId = Int()
    var storeName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStore()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath)  as! StoreCell
       
        let singleStore = stores[indexPath.row]
        cell.storeNameLabel.text = singleStore.name
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleStore = stores[indexPath.row]
        self.storeId = singleStore.id
        self.storeName = singleStore.name
        self.navigateToStoresEmployees()
    }
    
    func tapEditButton(cell: StoreCell, id: Int) {
        self.navigateToEditStore()
    }

    private func navigateToEditStore() {
        performSegue(withIdentifier: "fromStoES", sender: self)
    }
    
    private func navigateToStoresEmployees() {
        performSegue(withIdentifier: "fromStoSE", sender: self)
    }

    private func getStore() {
        ManagementNetworkManager.service.getUserStore { (stores, error) in
            self.stores = stores ?? [Store]()
            self.collectionView.reloadData()
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromStoSE" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? StoresEmployeesVC {
                destVC.storeId = storeId
                destVC.nameOfStore = storeName
            }
        }
    }
}
