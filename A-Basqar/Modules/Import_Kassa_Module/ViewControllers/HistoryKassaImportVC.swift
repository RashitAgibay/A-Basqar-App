//
//  HistoryKassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class HistoryKassaImportVC: DefaultVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var histories = [Income]()
    var checkId = Int()
    var historyId = Int()

    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        getCheckHistory()
    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        getCheckHistory()
        sender.endRefreshing()
    }
    
    private func getCheckHistory() {
        IncomesNetworkManager.service.getIncomesHistory { (incomes, error) in
            self.histories = incomes ?? [Income]()
            self.histories.reverse()
            self.collectionView.reloadData()
        }
    }
}

extension HistoryKassaImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "historyKassaExportCell", for: indexPath) as! HistoryKassaExportCell
        
        let singleIncome = histories[indexPath.row]
        cell.billLabel.text = "Приходная касса#\(singleIncome.id ?? 0)"
        cell.contragentNameLabel.text = singleIncome.contragent?.name
        cell.dateLabel.text = singleIncome.date
        cell.priceLabel.text = "\(singleIncome.fact_cash ?? "") тенге"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleIncome = histories[indexPath.row]
        self.checkId = singleIncome.id!
        self.navigateToHistoryKassaItem()
    }
}

extension HistoryKassaImportVC {
    private func navigateToHistoryKassaItem() {
        performSegue(withIdentifier: "fromHKItoHKII", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHKItoHKII" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? HistoryKassaImportItemVC {
                destVC.checkID = self.checkId
            }
        }
    }
}



