//
//  PlaceListVC.swift
//  A-Basqar
//
//  Created by iliyas on 20.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class PlaceListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var storeList = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStore()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "buyerCell", for: indexPath)  as! BuyerCompanyCell
        self.setupCell(cell: cell)
        
        let currentStore = storeList[indexPath.row]
        cell.BuyerCompanyName.text = currentStore.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentStore = storeList[indexPath.row]
        saveStoreInfo(id: currentStore.id!, name: currentStore.name!)
        navigateToMain()
    }

    private func setupCell(cell: BuyerCompanyCell) {
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
    
    private func getStore() {
        ManagementNetworkManager.service.getUserStore { (stores, error) in
            self.storeList = stores ?? [Store]()
            self.collectionView.reloadData()
        }
    }
    
    private func saveStoreInfo(id: Int, name: String) {
        UserDefaults.standard.setValue(id, forKey: selectedStoreId)
        UserDefaults.standard.setValue(name, forKey: selectedStoreName)
    }
    
    private func navigateToMain() {
        performSegue(withIdentifier: "fromMPLtoMM", sender: self)
    }
}
