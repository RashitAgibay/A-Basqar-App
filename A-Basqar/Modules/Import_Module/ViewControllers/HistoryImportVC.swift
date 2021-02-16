//
//  HistoryImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class HistoryImportVC: DefaultVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var historyID = Int()
    var historyList = [ImportCartObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistory()
    }
    
    private func getHistory() {
        ImportNetworkManager.service.getHistory { (importObject, error) in
            self.historyList = importObject ?? [ImportCartObject]()
            self.historyList.reverse()
            self.collectionView.reloadData()
        }
    }
}

extension HistoryImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryImportCell
        
        let currentHistory = historyList[indexPath.row]
        cell.importNameLabel.text = "Закуп #\(currentHistory.id!)"
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

extension HistoryImportVC {
    private func navigateToHistoryItem() {
        performSegue(withIdentifier: "fromHistoryToHistoryItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHistoryToHistoryItem" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? HistoryItemImportVC {
                destVC.historyID = self.historyID
            }
        }
    }
}
