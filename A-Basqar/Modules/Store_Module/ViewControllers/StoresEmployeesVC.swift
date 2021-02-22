//
//  StoresEmployeesVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class StoresEmployeesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storeName: UILabel!
    
    var storeId = Int()
    var nameOfStore = String()
    var userList = [UserProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        storeName.text = nameOfStore
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "storeEmployeesCell", for: indexPath)  as! StoreEmployeesCell
        
        let currentUser = userList[indexPath.row]
        cell.employeeNameLabel.text = currentUser.fullname
        cell.storeNameLabel.text = currentUser.store.name
            
        return cell
    }
    
    private func getUsers() {
        ManagementNetworkManager.service.getExactStoreUsers(storeId: storeId) { (users, error) in
            self.userList = users ?? [UserProfile]()
            self.collectionView.reloadData()
        }
    }
}
