//
//  SellingGoodsBasketVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 1/22/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class SellingGoodsBasketVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "userToken"
    var categoryID: Int = 0
    var selectedGoodID: Int = 0
    
    var good_amount: String = "1"
    
    
    var export_price: String = "0"
    var import_price: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("category id is \(categoryID)")
        load_and_refresh_data()
        
    }
    
    func load_and_refresh_data() {
        get_goods_from_category_api()
    }
    
    func go_to_the_next_page() {
        performSegue(withIdentifier: "tomainsellingpagefromgoods", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodListInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buygoodCell", for: indexPath) as! BuyProductAddGoodCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.googImageView.layer.cornerRadius = 10
        
        let good = goodListInfo[indexPath.row] as! NSDictionary
        let goodID = good["id"] as! Int
        let export_price = good["export_price"] as! Int
        let goods = good["goods"] as! NSDictionary
        let goodName = goods["name"] as! String
        let goodAmount = good["nums"] as! Int
        let catDict = goods["category"] as! NSDictionary
        let catId = catDict["id"] as! Int
        let goodImageUrl = goods["goods_image"] as! String
        
        
        if goodName != "" {
            cell.nameLabel.text = goodName as! String
        }
        
        cell.balanceLabel.text = "\(goodAmount)"
        cell.cashLabel.text = "\(export_price) тенге "
        cell.googImageView.sd_setImage(with: URL(string: goodImageUrl), placeholderImage: UIImage(named: "img1"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let good = goodListInfo[indexPath.row] as! NSDictionary
        
        let good_id = good["id"] as! Int
        selectedGoodID = good_id
        
        let good_import_price = good["import_price"] as! Int
        let good_export_price = good["export_price"] as! Int
        
        
        import_price = "\(good_import_price)"
        export_price = "\(good_export_price)"
        
        ShowAlertControllerWithTwoTextFields()
        
//        print("tapped good id \(selectedGoodID)")
//        print("import price \(import_price)")
    }

    
    func get_goods_from_category_api() {
        do {
            
            self.reacibility = try Reachability.init()
        }
        
        catch {
        
        }
        
        if ((reacibility!.connection) != .unavailable) {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
            let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = goodListUrl
            
            let requestOfApi = AF.request("\(encodeURL)?cat_id=\(categoryID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request)
//                print(response.result)
//                print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                    
                    }
                    else {
                        
                        let resultValue = payload as! NSArray
                        
                        goodListInfo = NSMutableArray(array: resultValue)
                        self.collectionView.reloadData()
                    }
                
                case .failure(let error):
                    
                    print(error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                }
            })
        }
        
        else {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    
    func SendGoodToBasketApi() {
        
        do {
            
            self.reacibility = try Reachability.init()
        }
        
        catch {
            print("unable to start notifier")
        }
        
        if ((reacibility!.connection) != .none) {
            
//            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let params = [
                
                "goods":"\(selectedGoodID)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "nums":good_amount.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            let encodeURL = basketUrl
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
            
            })
        }
        
        else {
            
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    
    func send_good_price_api() {
        
        do {
            
            self.reacibility = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        }
        
        if ((reacibility!.connection) != .none) {
            
            
            let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let params = [
                
                "import_price":import_price.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                "export_price":export_price.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                
            ]
            
            let encodeURL = goodListUrl
            
            let requestOfApi = AF.request(encodeURL + "\(selectedGoodID)/", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
            })
        }
        
        else {
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    
    func ShowErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in }
        
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }
    
    func ShowErrorsAlertWithOneCancelButton(message: String) {
        
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in }
        
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }
    
    func ShowAlertControllerWithTwoTextFields(){
        let alertController = UIAlertController(title: "", message: "Введите количество...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            let amountAlertTextField = alertController.textFields?[0].text
            let cashAlertTextField  = alertController.textFields?[1].text
            self.export_price = cashAlertTextField as! String

//            print("export price \(self.export_price)")
            
            if amountAlertTextField != "" {
                self.good_amount = amountAlertTextField!
//                print("good amout is more than 1")
            }

            else {
                self.good_amount = "1"
//                print("good amout is  1")
            }
            
            self.send_good_price_api()
            self.SendGoodToBasketApi()
            self.send_good_price_api() // 2 рет запрос жібермесе жасамай тұр
            self.go_to_the_next_page()
            
            
            
            
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "1"
            textfield.keyboardType = .numberPad
//            textfield.text = "1"
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "\(self.export_price)"
            textfield.keyboardType = .numberPad
//            textfield.text = self.export_price
        }
        
        
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
    }

}

