//
//  ImportListKassaExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import RealmSwift

class ImportListKassaExportVC: DefaultVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var importList = [ImportCartObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImportsList()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        navigateToMainKassaExport()
    }
    
    private func getImportsList() {
        ImportNetworkManager.service.getHistory { (imports, error) in
            self.importList = imports ?? [ImportCartObject]()
            self.importList.reverse()
            self.collectionView.reloadData()
        }
    }
}

extension ImportListKassaExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return importList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "importListKassaExportCell", for: indexPath) as! ImportListKassaExportCell
        
        let singleImport = importList[indexPath.row]
        cell.contragentNameLabel.text = singleImport.contragent?.name
        cell.dateLabel.text = singleImport.date
        cell.priceLabel.text = singleImport.cashSum
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleImport = importList[indexPath.row]
        
        saveCurrentBillInSystem(importName: "Закуп #\(singleImport.id ?? 0)", billNumber: "Чек #\(singleImport.id ?? 0)", date: singleImport.date ?? "", contragent: singleImport.contragent?.name ?? "", totalMoney: singleImport.cashSum ?? "", importId: singleImport.id!)
        
    }
    
}

extension ImportListKassaExportVC {
    private func navigateToMainKassaExport() {
        performSegue(withIdentifier: "fromImportListKassaExportToMainKassaExport", sender: self)
    }
}



extension ImportListKassaExportVC {
    
    private func saveCurrentBillInSystem(importName: String, billNumber: String, date: String, contragent: String, totalMoney: String, importId: Int) {
        
        let bill = OutcomeBill()
        bill.importNubmer = importName
        bill.billNumber = billNumber
        bill.date = date
        bill.contragent = contragent
        bill.totalMoney = totalMoney
        bill.importId = importId
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(bill)
        }
        
        var resulsts: Results<OutcomeBill>!
        resulsts = realm.objects(OutcomeBill.self)

        navigateToMainKassaExport()
    }
}
