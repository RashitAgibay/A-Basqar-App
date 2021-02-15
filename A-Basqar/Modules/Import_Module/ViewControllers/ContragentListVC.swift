//
//  ContragentListVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/4/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class ContragentListVC: DefaultVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var contrList = [Contragent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConrtList()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigateToMainImport()
    }
    
    private func getConrtList() {
        ManagementNetworkManager.service.getContrList { (contrs, error) in
            self.contrList = contrs ?? [Contragent]()
            self.collectionView.reloadData()
        }
    }
    
}


extension ContragentListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contrList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "contragentListCell", for: indexPath) as! ContragentListImportCell
        
        let currentContr = contrList[indexPath.row]
        cell.delegate = self
        cell.contrID = currentContr.id
        cell.contragentNameLabel.text = currentContr.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentContr = contrList[indexPath.row]
        
        self.saveLastImportContr(contrName: currentContr.name ?? "", contrID: currentContr.id ?? 0)
        self.navigateToMainImport()
    }
}


extension ContragentListVC: ContragentListImportCellDelegate {
    func tapToUpdateContragent(cell: ContragentListImportCell, id: Int) {
        
        self.navigateToUpdateContrInfo()
    }
}

extension ContragentListVC {
    private func navigateToUpdateContrInfo() {
        performSegue(withIdentifier: "fromContrListToUpdateContr", sender: self)
    }
    
    private func navigateToMainImport() {
        performSegue(withIdentifier: "fromContrListToMainImport", sender: self)
    }
}

extension ContragentListVC {
    private func saveLastImportContr(contrName: String, contrID: Int) {
        UserDefaults.standard.set(contrName, forKey: selectedImportContr)
        UserDefaults.standard.set(contrID, forKey: selectedImportContrID)
    }
}
