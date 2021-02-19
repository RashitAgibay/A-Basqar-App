//
//  ExportListKassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import RealmSwift

class ExportListKassaImportVC: DefaultVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var exportList = [ExportCartObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getExportsList()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        navigateToMainKassaExport()
    }
    
    private func getExportsList() {
        ExportNetworkManager.service.getHistory { (exports, error) in
            self.exportList = exports ?? [ExportCartObject]()
            self.exportList.reverse()
            self.collectionView.reloadData()
        }
    }
}

extension ExportListKassaImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exportList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "importListKassaExportCell", for: indexPath) as! ImportListKassaExportCell
        
        let singleImport = exportList[indexPath.row]
        cell.contragentNameLabel.text = singleImport.contragent?.name
        cell.dateLabel.text = singleImport.date
        cell.priceLabel.text = singleImport.cashSum
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleImport = exportList[indexPath.row]
        
        saveCurrentBillInSystem(importName: "Продажа #\(singleImport.id ?? 0)", billNumber: "Чек #\(singleImport.id ?? 0)", date: singleImport.date ?? "", contragent: singleImport.contragent?.name ?? "", totalMoney: singleImport.cashSum ?? "", historyID: singleImport.id!)
    }
}

extension ExportListKassaImportVC {
    private func navigateToMainKassaExport() {
        performSegue(withIdentifier: "fromElKItoMKI", sender: self)
    }
}

extension ExportListKassaImportVC {
    
    private func saveCurrentBillInSystem(importName: String, billNumber: String, date: String, contragent: String, totalMoney: String, historyID: Int) {
        
        var bill = IncomeBill()
        bill.importNubmer = importName
        bill.billNumber = billNumber
        bill.date = date
        bill.contragent = contragent
        bill.totalMoney = totalMoney
        bill.historyID = historyID
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(bill)
        }
        
        var resulsts: Results<IncomeBill>!
        resulsts = realm.objects(IncomeBill.self)
        
        navigateToMainKassaExport()
    }
}
