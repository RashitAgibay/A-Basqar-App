//
//  HistoryItemExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class HistoryItemExportVC: DefaultVC {
    
    @IBOutlet weak var importNameLabel: UILabel!
    @IBOutlet weak var contrNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var exportCartObject = ExportCart()
    var historyID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryItem(id: historyID)
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigateToMainImport()
    }
    
    private func getHistoryItem(id: Int) {
        ExportNetworkManager.service.getHistoryItem(historyId: id) { (exportObject, error) in
            self.exportCartObject = exportObject ?? ExportCart()
            self.collectionView.reloadData()
            self.importNameLabel.text = "Продажа #\(exportObject?.cartObject?.id ?? 0)"
            self.contrNameLabel.text = exportObject?.cartObject?.contragent?.name
            self.totalPriceLabel.text = "\(self.calculateTotalSun(list: (exportObject?.cartProduct)!)) тг"
        }
    }
}

extension HistoryItemExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exportCartObject.cartProduct?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyItemExportCell", for: indexPath) as! HistoryItemExportCell
        
        let singleProd = exportCartObject.cartProduct?[indexPath.row]
        cell.productNameLabel.text = singleProd?.exportProduct?.product?.productName
        cell.productPriceLabel.text = "\(singleProd?.exportProduct?.product?.productImportPrice ?? 0) тг"
        cell.productAmountLabel.text = "\(singleProd?.amount ?? 0)"
        cell.productTotalPriceLabel.text = "\((singleProd?.exportProduct?.product?.productImportPrice ?? 0) * (singleProd?.amount ?? 0)) тг"
        
        return cell
    }
    
    private func calculateTotalSun(list: [ExportCartProduct]) -> Int {
        var totalSum = Int()
        for item in list {
            totalSum += (item.exportProduct?.product?.productImportPrice ?? 0) * (item.amount ?? 0)
        }
        return totalSum
    }
}

extension HistoryItemExportVC {
    private func navigateToMainImport() {
        performSegue(withIdentifier: "fromHIEtoME", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromHIEtoME" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MainImportVC {
                destVC.selectegTag = 1
            }
        }
    }
}

