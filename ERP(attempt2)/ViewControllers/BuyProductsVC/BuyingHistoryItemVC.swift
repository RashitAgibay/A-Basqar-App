//
//  BuyingHistoryItemVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/3/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class BuyingHistoryItemVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    

    
    @IBOutlet weak var buyingNameLabel: UILabel!
    @IBOutlet weak var buyersName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var historyItemID: Int = 0
    var goodsListArray: NSArray = []
    var selected_segment_id: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        priceLabel.layer.cornerRadius = 20
        priceLabel.layer.borderWidth = 1
        
        //MARK: - (id - 4651) Кез келген hex кодттағы түсті UIColor типіне ауыстыру
        priceLabel.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        saveButton.layer.cornerRadius = 20
        saveButton.dropShadowforButton()
        
        getHistoryItemListApi()
        
//        print("here is a historyItemID: \(historyItemID)")
        
        // Do any additional setup after loading the view.
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
        
        
        let goodsFromItemList = goodsListArray[indexPath.row] as! NSDictionary
        
        let goods_nums = goodsFromItemList["nums"] as! Int
        let goods_price = goodsFromItemList["goods_price"] as! Int
        
        let goods = goodsFromItemList["goods"] as! NSDictionary
        let import_price = goods["import_price"] as! Int
        
        let eachGoods = goods["goods"] as! NSDictionary
        
        let name = eachGoods["name"] as! String
        let goods_image_url = eachGoods["goods_image"] as! String
        
        
//        print(name)
//        print(goods_image_url)
//        print(goods_nums)
//        print(goods_price)
//        print(import_price)
        
        var total_price = goods_nums * import_price
        
        cell.imageView.sd_setImage(with: URL(string: goods_image_url), placeholderImage: UIImage(named: "img1"))
        cell.productName.text = name
        cell.productPrice.text = "\(import_price) тенге"
        cell.productAmount.text = "\(goods_nums)"
        cell.prodeuctTotalPrice.text = "\(total_price) тенге"
        
        
        return cell
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        performSegue(withIdentifier: "backtoMenfromhistoryitemlis", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backtoMenfromhistoryitemlis" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? BuyProductVC {
                targetController.selectedSegmentId = selected_segment_id
            }
        }
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
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

extension BuyingHistoryItemVC {
    
    func getHistoryItemListApi() {
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
                
                let encodeURL = buyingHistoryUrl
                
                let requestOfApi = AF.request(encodeURL+"\(historyItemID)/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                    
    //                print(response.request)
    //                print(response.result)
    //                print(response.response)
                    
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
                            
                            
                            self.buyingNameLabel.text = history_name
                            self.buyersName.text = seller_company_name
                            self.priceLabel.text = "\(sum)"
                            
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
