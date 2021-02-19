//
//  ContragenListKassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class ContragenListKassaImportVC: DefaultVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var contrList = [Contragent]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getConrtList()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigateToMainExport()
    }
    
    private func getConrtList() {
        ManagementNetworkManager.service.getContrList { (contrs, error) in
            self.contrList = contrs ?? [Contragent]()
            self.collectionView.reloadData()
        }
    }
}


extension ContragenListKassaImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contrList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "contragentListExportListCell", for: indexPath) as! ContragentListExportListCell
        
        let currentContr = contrList[indexPath.row]
        cell.contrID = currentContr.id
        cell.conrtagentNameLabel.text = currentContr.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentContr = contrList[indexPath.row]
        
        self.saveContrInfoInSystem(contrName: currentContr.name ?? "", contrId: currentContr.id ?? 0)
        self.navigateToMainExport()
    }
}


extension ContragenListKassaImportVC {
    private func navigateToMainExport() {
        performSegue(withIdentifier: "fromCLKItoMKI", sender: self)
    }
}



extension ContragenListKassaImportVC {
    
    private func saveContrInfoInSystem(contrName: String, contrId: Int) {
        var contr = ImportKassaContragent()
        contr.contragnetName = contrName
        contr.contragentId = contrId
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(contr)
        }
    }
}
