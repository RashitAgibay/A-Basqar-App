//
//  SellingHistoryItemVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class SellingHistoryItemVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var sellingNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var historyItemId: Int = 0
    
    var goodsListArray: NSArray = []
    var selected_segment_id: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("here is the gistory item id: \(historyItemId)")
        
        totalPriceLabel.layer.cornerRadius = 20
        totalPriceLabel.layer.borderWidth = 1
        
        //MARK: - (id - 4651) Кез келген hex кодттағы түсті UIColor типіне ауыстыру
        totalPriceLabel.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        saveButton.layer.cornerRadius = 20
        saveButton.dropShadowforButton()
        
        get_gistory_item_info()
        
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        performSegue(withIdentifier: "seguewwwwwww", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguewwwwwww" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? SellingProdVC {
                targetController.selected_segment_sender = selected_segment_id
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyItem", for: indexPath) as! BuyingHistoryItemCell
        
        cell.contentView.layer.cornerRadius = 10
               cell.layer.shadowColor = UIColor.gray.cgColor
               cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
               cell.layer.shadowOpacity = 0.5
               cell.layer.masksToBounds = false
               cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.amountCard.layer.cornerRadius = 10
               cell.amountCard.layer.backgroundColor = UIColor.white.cgColor
               cell.amountCard.layer.borderWidth = 1
               cell.amountCard.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
               
        
        
        cell.totalPriceCard.layer.cornerRadius = 10
               cell.totalPriceCard.layer.backgroundColor = UIColor.white.cgColor
               cell.totalPriceCard.layer.borderWidth = 1
               cell.totalPriceCard.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
               
               
        cell.imageView.layer.cornerRadius = 10
        
        cell.imageView.image = UIImage(named: historyBuyingItemImages[indexPath.row])
        cell.productName.text = historyBuyingItemProducts[indexPath.row]
        cell.productPrice.text = "\(historyBuyingItemPrices[indexPath.row])"
        cell.productAmount.text = "\(historyBuyingItemAmounts[indexPath.row])  кг"
        cell.prodeuctTotalPrice.text = "\(historyBuyingItemTotalPrices[indexPath.row]) тенге"
        
        
        let goodsFromItemList = goodsListArray[indexPath.row] as! NSDictionary
        
        let goods_nums = goodsFromItemList["nums"] as! Int
        let goods_price = goodsFromItemList["goods_price"] as! Int
        
        let goods = goodsFromItemList["goods"] as! NSDictionary
        let export_price = goods["export_price"] as! Int
        
        let eachGoods = goods["goods"] as! NSDictionary
        
        let name = eachGoods["name"] as! String
        let goods_image_url = eachGoods["goods_image"] as! String
        
        var total_price = goods_nums * export_price
        
        cell.imageView.sd_setImage(with: URL(string: goods_image_url), placeholderImage: UIImage(named: "img1"))
        cell.productName.text = name
        cell.productPrice.text = "\(export_price) тенге"
        cell.productAmount.text = "\(goods_nums)"
        cell.prodeuctTotalPrice.text = "\(total_price) тенге"
        
        return cell
    }
    
    //MARK: - (id - 4651) Кез келген hex кодттағы түсті UIColor типіне ауыстыру
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension SellingHistoryItemVC {
    
    func get_gistory_item_info() {
            do {
                reacibility = try Reachability.init()
                
            }
            catch {
                
            }
            if ((reacibility!.connection) != .unavailable){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
                let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                ]
                
                let encodeURL = sellingHistoryUrl
                
                let requestOfApi = AF.request(encodeURL+"\(historyItemId)/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
//                    
//                    print(response.request)
//                    print(response.result)
//                    print(response.response)
                    
                    switch response.result {

                    case .success(let payload):
                        MBProgressHUD.hide(for: self.view, animated: true)

                        if let x = payload as? Dictionary<String,AnyObject> {
//                            print(x)
                            let resultValue = x as! NSDictionary
                            //categoryInfo = NSMutableArray(array: resultValue) as! NSArray
                            
                            self.goodsListArray = resultValue["history_goods"] as! NSArray
                            
                            let history_name = resultValue["history_name"] as! String
                            let seller_company_name_dict = resultValue["company"] as! NSDictionary
                            let seller_company_name = seller_company_name_dict["company_name"] as! String
                            let sum = resultValue["sum"] as! Int
                            
                            
                            self.sellingNameLabel.text = history_name
                            self.sellerNameLabel.text = seller_company_name
                            self.totalPriceLabel.text = "\(sum)"
                            
//                            print("here is a \(self.goodsListArray)")

                            self.collectionView.reloadData()
                        }

                        else {
                            let resultValue = payload as! NSArray
                            //print("осы жерде категори инфо")
                            //    print(resultValue)

                            buyingHistoryInfo = NSMutableArray(array: resultValue)
                            self.collectionView.reloadData()

                            //print("осы жерде категори инфо")
                            //print(categoryInfo)

                        }
                    case .failure(let error):
                        print(error)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")

                    }

                })
                
            }
            else {
                //print("internet is not working")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                
            }
            
        }
        
        func ShowErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in}
            alertController.addAction(action)
            self.present(alertController,animated: true, completion: nil)
        }
        
        func ShowErrorsAlertWithOneCancelButton(message: String) {
            let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
            }
            alertController.addAction(action)
            self.present(alertController,animated: true, completion: nil)
        }
}
