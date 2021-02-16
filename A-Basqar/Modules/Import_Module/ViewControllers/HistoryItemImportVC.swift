//
//  HistoryItemImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class HistoryItemImportVC: DefaultVC {

    @IBOutlet weak var importNameLabel: UILabel!
    @IBOutlet weak var contrNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var importCartObject = ImportCart()
    var historyID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryItem(id: historyID)
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigateToMainImport()
    }
    
    private func getHistoryItem(id: Int) {
        ImportNetworkManager.service.getHistoryItem(historyId: id) { (importObject, error) in
            self.importCartObject = importObject ?? ImportCart()
            self.collectionView.reloadData()
            self.importNameLabel.text = "Закуп #\(importObject?.cartObject?.id ?? 0)"
            self.contrNameLabel.text = importObject?.cartObject?.contragent?.name
            self.totalPriceLabel.text = "\(self.calculateTotalSun(list: (importObject?.cartProduct)!)) тг"
        }
    }
}

extension HistoryItemImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return importCartObject.cartProduct?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyItem", for: indexPath) as! HistoryItemImportCell
        
        let singleProd = importCartObject.cartProduct?[indexPath.row]
        cell.productNameLabel.text = singleProd?.importProduct?.product?.productName
        cell.productPriceLabel.text = "\(singleProd?.importProduct?.product?.productImportPrice ?? 0) тг"
        cell.productAmountLabel.text = "\(singleProd?.amount ?? 0)"
        cell.productTotalPriceLabel.text = "\((singleProd?.importProduct?.product?.productImportPrice ?? 0) * (singleProd?.amount ?? 0)) тг"
        
        return cell
    }
    
    private func calculateTotalSun(list: [ImportCartProduct]) -> Int {
        var totalSum = Int()
        for item in list {
            totalSum += (item.importProduct?.product?.productImportPrice ?? 0) * (item.amount ?? 0)
        }
        return totalSum
    }
}

extension HistoryItemImportVC {
    private func navigateToMainImport() {
        performSegue(withIdentifier: "fromHistoryitemToMainImport", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromHistoryitemToMainImport" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MainImportVC {
                destVC.selectegTag = 1
            }
        }
    }
}

