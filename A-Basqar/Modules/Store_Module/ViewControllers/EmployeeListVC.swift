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
    
    var users = [UserProfile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath)  as! StoreCell
        cell.delegate = self
        
        let currentUser = users[indexPath.row]
        
        cell.storeNameLabel.text = currentUser.fullname
        cell.employeeLabel.text = currentUser.store.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        self.navigateToEmployeeFuncs()
    }
    
    func tapEditButton(cell: StoreCell, id: Int) {
        self.navigateToEditEmployeeData()
    }
    
    private func navigateToEditEmployeeData() {
        performSegue(withIdentifier: "fromELtoEED", sender: self)
    }
    
    private func navigateToEmployeeFuncs() {
        performSegue(withIdentifier: "fromELtoEF", sender: self)
    }
    
    private func getUsers() {
        ManagementNetworkManager.service.getCompanyAllUsers { (users, error) in
            self.users = users ?? [UserProfile]()
            self.collectionView.reloadData()
        }
    }
}
