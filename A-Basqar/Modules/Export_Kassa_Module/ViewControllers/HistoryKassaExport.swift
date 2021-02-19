//
//  HistoryKassaExport.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire

class HistoryKassaExport: DefaultVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var histories = [Expense]()
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
        ExpensesNetworkManager.service.getExpensesHistory { (expenses, error) in
            self.histories = expenses ?? [Expense]()
            self.histories.reverse()
            self.collectionView.reloadData()
        }
    }
}

extension HistoryKassaExport: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "historyKassaExportCell", for: indexPath) as! HistoryKassaExportCell
        
        let singleExpense = histories[indexPath.row]
        cell.billLabel.text = "Расходая касса#\(singleExpense.id ?? 0)"
        cell.contragentNameLabel.text = singleExpense.contragent?.name
        cell.dateLabel.text = singleExpense.date
        cell.priceLabel.text = "\(singleExpense.fact_cash ?? "") тенге"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleExpense = histories[indexPath.row]
        self.checkId = singleExpense.id ?? 0
        self.navigateToHistoryKassaItem()
        
    }
    
}

extension HistoryKassaExport {
    private func navigateToHistoryKassaItem() {
        performSegue(withIdentifier: "fromHKEtoHKEI", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHKEtoHKEI" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? HistoryKassaExportItemVC {
                destVC.checkID = self.checkId
                
                if self.historyId != 0 {
                    destVC.historyId = self.historyId
                }
            }
        }
    }
}



