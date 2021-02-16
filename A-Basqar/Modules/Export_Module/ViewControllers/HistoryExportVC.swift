//
//  HistoryExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class HistoryExportVC: DefaultVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var historyID = Int()
    var historyList = [ExportCartObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistory()
    }
    
    private func getHistory() {
        ExportNetworkManager.service.getHistory { (exportObject, error) in
            self.historyList = exportObject ?? [ExportCartObject]()
            self.historyList.reverse()
            self.collectionView.reloadData()
        }
    }
}

extension HistoryExportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "historyExportCell", for: indexPath) as! HistoryExportCell
        
        let currentHistory = historyList[indexPath.row]
        cell.exportNameLabel.text = "Продажа #\(currentHistory.id!)"
        cell.conrtagentNameLabel.text = currentHistory.contragent?.name
        cell.dateLabel.text = currentHistory.date
        cell.priceLabel.text = currentHistory.cashSum ?? "" + "тг"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentHistory = historyList[indexPath.row]
        self.historyID = currentHistory.id!
        self.navigateToHistoryItem()
    }
}

extension HistoryExportVC {
    private func navigateToHistoryItem() {
        performSegue(withIdentifier: "fromHEtoHIE", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHEtoHIE" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? HistoryItemExportVC {
                destVC.historyID = self.historyID
            }
        }
    }
}
