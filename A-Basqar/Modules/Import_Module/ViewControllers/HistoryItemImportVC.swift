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
    
    var productArray = NSArray()
    var historyID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getProductList(historyID: historyID)
    }
    


    @IBAction func tapBackButton(_ sender: Any) {
        
        self.navigateToMainImport()
    }
    
}


extension HistoryItemImportVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyItem", for: indexPath) as! HistoryItemImportCell
        
        let singleProduct  = productArray[indexPath.row] as! NSDictionary
        let firstGoods = singleProduct["goods"] as! NSDictionary
        let secondGoods = firstGoods["goods"] as! NSDictionary
        let productName = secondGoods["name"] as! String
        
        let productPrice = singleProduct["goods_price"] as! Int
        let productAmount = singleProduct["nums"] as! Int
        let totalPrice = productPrice * productAmount
        
        if secondGoods["goods_image"] != nil {
            
            let productImageUrl = secondGoods["goods_image"] as! String
            
            cell.productImageView.sd_setImage(with: URL(string: productImageUrl), placeholderImage: UIImage(named: "img1"))
        }
        
        cell.productNameLabel.text = productName
        cell.productPriceLabel.text = "\(productPrice) тг"
        cell.productAmountLabel.text = "\(productAmount)"
        cell.productTotalPriceLabel.text = "\(totalPrice) тг"
        
        
        return cell
    }
    
}

extension HistoryItemImportVC {
    
    func getProductList(historyID: Int) {
        
        do {
            
            self.reachability = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        }
        
        if ((reachability?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = importHistoryListURL + "\(historyID)/"
            let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request)
//                print(response.result)
//                print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                    
                        let historyName = x["history_name"] as! String
                        let company = x["company"] as! NSDictionary
                        let contrName = company["company_name"] as! String
                        let totalSum = x["sum"] as! Int
                        
                        let productArray = x["history_goods"] as! NSArray
                        
                        self.productArray = productArray
                        
                        self.importNameLabel.text = "Покупка #\(historyName)"
                        self.contrNameLabel.text = contrName
                        self.totalPriceLabel.text = "\(totalSum) тенге"
                        
                        
                        self.collectionView.reloadData()

                    }
                    
                    else {
                        
                    }
                
                case .failure(let error):
                    
                    print(error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            })
        }
        
        else {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
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

