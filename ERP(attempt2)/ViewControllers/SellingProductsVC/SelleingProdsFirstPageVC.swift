//
//  SelleingProdsFirstPageVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class SelleingProdsFirstPageVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sellingCard: UIView!
    @IBOutlet weak var sellingTotalPrice: UILabel!
    @IBOutlet weak var sellingCompany: UIButton!
    @IBOutlet weak var sellingSale: UITextField!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var makeSaleButton: UIButton!
    
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "userToken"
    var companyNameFromList: String = "Покупатель..."
    var goodPriceFromList: String = "goodPriceFromList"
    var eachPrices: String = "eachPrices"
    var idForDeleting: Int!
    var totalCash: Int! = 0
    var totalCashAfterPercentaging: Int = 0
    
    var companyIdFromList: Int = 0
    
    var newDataInfoFromApiArray: NSMutableArray = []
    
    var testName: String! = ""
    var testSum: NSArray = []
    
    
    var sumOfPriceForAllGoods: Array<Int> = []
    var sumOfCountForAllGoods: Array<Int> = []
    
    var import_price  = String()
    var export_price  = String()
    var good_amount = String()
    var goodIdFromVC = Int()
    var selected_good_id = Int()
    
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
    }()
    
    
    
    
    override func viewDidLoad() {
        
        update_page_info()
        
        super.viewDidLoad()

//        print("here is the company id \(companyIdFromList)")
        
        
        sellingCard.layer.cornerRadius = 10
        sellingCard.dropShadow()
        sellingCard.layer.backgroundColor = UIColor.white.cgColor

        sellButton.layer.cornerRadius = 10
        sellButton.dropShadowforButton()
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.dropShadowforButton()
        
        sellingCompany.layer.cornerRadius = 5
        sellingCompany.dropShadowforButton()
        sellingCompany.setTitle(companyNameFromList, for: .normal)
        
        makeSaleButton.layer.cornerRadius = 5
        makeSaleButton.dropShadowforButton()
        
        collectionView.refreshControl = refreshControl
        
        

        self.makeSaleButton.setTitle("0%", for: .normal)
        
        sellingTotalPrice.text = "\(totalCash!)"
        
        
        let companyNameDbValue = UserDefaults.standard.string(forKey: sellerCompanyNameInLocalDB)
        
        if companyNameDbValue == nil {
            sellingCompany.setTitle("Котрагент...", for: .normal)
        }
        else {
            sellingCompany.setTitle(companyNameDbValue, for: .normal)
        }
        
    }
    
    func update_page_info() {
        
        GoodInBasketApi()
        getTotalSumApi()
        collectionView.reloadData()
    }
    
    @IBAction func tapSellingBurron(_ sender: Any) {
        
//        print(" here is the \(companyNameFromLi/st)" )
        
//        debug_print(message: "here is button title", object: sellingCompany.titleLabel?.text)
        
        if  sellingCompany.titleLabel?.text != "Котрагент..." {
            
            
            
            send_goods_to_selling_history_api()
            performSegue(withIdentifier: "tokassadocsfromsellinbasket", sender: self)
            
            
        }
        else {
            ShowErrorsAlertWithOneCancelButton(message: "Выберите покупателя...")
        }
        
//        print(totalCash!)
    }
    
    @objc private func refreshData(sender: UIRefreshControl){

        update_page_info()
        sender.endRefreshing()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsInBasket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellProducts", for: indexPath) as! SellingProdsCell
        let totalPriceOfGood: Int!
        
        
        
        
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        cell.sellingProdPriceCard.layer.cornerRadius=10
        cell.sellingProdPriceCard.layer.backgroundColor = UIColor.white.cgColor
        cell.sellingProdPriceCard.layer.borderWidth = 1
        cell.sellingProdPriceCard.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        cell.sellingProdImage.layer.cornerRadius = 10
        
        
        let good = goodsInBasket[indexPath.row] as! NSDictionary
        
        
        let goodCardID = good["id"] as! Int
        let goods = good["goods"] as! NSDictionary
        let goodAmount = good["nums"] as! Int
        
//        print("here is card id \(goodCardID)")
    
        
        let totalBalance = goods["nums"] as! Int // Общий остаток товара в складе
//        let import_price = goods["import_price"] as! Int
        let export_price = goods["export_price"] as! Int
        
        
        let eachgoods = goods["goods"] as! NSDictionary // Словарь для каждого товара
        
        let goodID = eachgoods["id"] as! Int
        let goodBarCode = eachgoods["goods_sn"] as! String
        
        let goodName = eachgoods["name"] as! String
        let goodImageUrl = eachgoods["goods_image"] as! String
        
       
        
        totalPriceOfGood = export_price * goodAmount
        
        
        
//        testSum.adding()
        
//        print("here is the totalPriceOfGood \(totalPriceOfGood!)")
//        totalCash += totalPriceOfGood
//        print("here is the totalCash \(totalCash!)")
//
//        sellingTotalPrice.text = "\(totalCash!)"
        
        cell.idOfGood = goodCardID
        cell.delegate = self
        
        
        cell.sellingProdName.text = goodName
        cell.sellingProdBalanace.text = "\(totalBalance)"
        cell.sellingProdPrice.text = "\(export_price)-тг"
        cell.sellingProdAmount.text = "\(goodAmount)"
        cell.sellingProdTotalPrice.text = "\(totalPriceOfGood!)-тг"
        
        cell.sellingProdImage.sd_setImage(with: URL(string: goodImageUrl), placeholderImage: UIImage(named: "img1"))
        
        
        
//        cell.sellingDeleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let good = goodsInBasket[indexPath.row] as! NSDictionary
            
            let nums = good["nums"] as! Int
            self.selected_good_id = good["id"] as! Int
            
            
            
            let goods = good["goods"] as! NSDictionary
            
            
            let goodId = goods["id"] as! Int
            self.goodIdFromVC = goodId
            
            let importPrice = goods["import_price"] as! Int
            let exportPrice = goods["export_price"] as! Int
            
            self.good_amount = "\(nums)"
            self.import_price = "\(importPrice)"
            self.export_price = "\(exportPrice)"
            
            ShowAlertControllerWithTwoTextFields()
        }
        
        func ShowAlertControllerWithTwoTextFields() {
            let alertController = UIAlertController(title: "", message: "Введите количество и цену...", preferredStyle: .alert)
            let addAction = UIAlertAction(title: "Изменить", style: .default) { (action) in
                
                
                
                let amountAlertTextField = alertController.textFields?[0].text
                let cashAlertTextField  = alertController.textFields?[1].text
                self.good_amount = amountAlertTextField as! String
                self.export_price = cashAlertTextField as! String
                

    //            debug_print(message: "import price", object: self.import_price)
    //            debug_print(message: "goods_amount", object: self.good_amount)
                

                self.sendSelectedGoodsPrice()
                self.sendSelectedGoodsAmount()
                self.update_page_info()
                
                
                
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
                
            }
            alertController.addTextField { (textfield) in
                textfield.placeholder = "\(self.good_amount)"
                textfield.keyboardType = .numberPad
//                textfield.text = "\(self.good_amount)"
            }
            alertController.addTextField { (textfield) in
                textfield.placeholder = "\(self.export_price)"
                textfield.keyboardType = .numberPad
//                textfield.text = "\(self.export_price)"
                
            }
            
            
            
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true, completion: nil)
        }
        
        
        func sendSelectedGoodsPrice() {
            
            do {
                
                self.reacibility = try Reachability.init()
            }
            
            catch {
                print("unable to start notifier")
            }
            
            if ((reacibility!.connection) != .none){
                
                let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                ]
                
                let params = [

                    "export_price":export_price.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                    "import_price":import_price.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                ]

                let encodeURL = goodListUrl
                let requestOfApi = AF.request(encodeURL + "\(goodIdFromVC)/", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in

                    self.update_page_info()
                    
        //                           print(response.request!)
        //                           print(response.result)
        //                           print(response.response)
                })
            }
            else {
                print("internet is not working")
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            }
        }
        
        
        func sendSelectedGoodsAmount() {
            
            do {
                self.reacibility = try Reachability.init()
            }
            
            catch {
                print("unable to start notifier")
            }
            
            if ((reacibility!.connection) != .none){
                
                let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                ]
                
                let params = [
                    
                    "goods":"\(self.goodIdFromVC)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                    "nums":self.good_amount.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                ]
                
                let encodeURL = basketUrl
                let requestOfApi = AF.request(encodeURL+"\(self.selected_good_id)/", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                               
                    self.update_page_info()
                    
        //                       print(response.request!)
        //                       print(response.result)
        //                       print(response.response)
                
                })
            }
            
            else {
                
                print("internet is not working")
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            }
        }
    
    
    
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let good = goodsInBasket[indexPath.row] as! NSDictionary
//        
//        let goodCardID = good["id"] as! Int
//        
//        idForDeleting = goodCardID
//        
//        
//        print(goodCardID)
//    }
    
    @objc func tapDeleteButton(){
//        print("\(idForDeleting) in \(testName)")
        print("tapped delete button in \(idForDeleting)")
    }
    
    @IBAction func tapMakeSaleButton(_ sender: Any) {
        
        ShowAlertControllerWithOneTextFields()
    }
    
    
     func GoodInBasketApi() {
                           
                           do {
                             self.reacibility = try Reachability.init()
                           }
                           
                           catch {
                            // print("unable to start notifier")
                            
                            
                           }
                           
                    if ((reacibility!.connection) != .unavailable){
                                              MBProgressHUD.showAdded(to: self.view, animated: true)
                               
                            //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
                        let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
    //                    print("token is \(token)")
                            
                            let headers: HTTPHeaders = [
                                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                                //"Authorization":"Token 1d61d12c174b38f660f8026bb3d2cc47b5bec66d".trimmingCharacters(in: .whitespacesAndNewlines),
                                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                                
                               ]
                                         
                               let encodeURL = basketUrl
                      
                        let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                               
                               requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                                   
    //                               print(response.request)
//                                   print(response.result)
    //                               print(response.response)
                                   
                                
                                
                                   switch response.result {

                                   case .success(let payload):
                                       MBProgressHUD.hide(for: self.view, animated: true)

                                     
                                       
                                       
                                       if let x = payload as? Dictionary<String,AnyObject> {
                                           print(x)

                                           //let resultValue = x as NSMutableArray
                                           //categoryInfo = NSMutableArray(array: resultValue) as! NSArray

                                       }

                                       else{
                                        let resultValue = payload as! NSArray
                                        //print("осы жерде категори инфо")
                                        //    print(resultValue)


                                        
                                        
                                        goodsInBasket = NSMutableArray(array: resultValue)
                                        self.newDataInfoFromApiArray = NSMutableArray(array: resultValue)
//                                        print("here starts a newDataInfoFromApiArray: \(self.newDataInfoFromApiArray)")
                                        self.collectionView.reloadData()

                                        

                                    }

                                   case .failure(let error):
                                       print(error)
                                       MBProgressHUD.hide(for: self.view, animated: true)
                                       self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")

                                   }

                               })
                               
                           }
                           
                           else{
                               //print("internet is not working")
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                           }
                           
                       }
                    
                    func ShowErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
                        
                         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                                   let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in
                                       
                                   }
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
    
    
//    func reloadData(notification:NSNotification){
//
//        self.collectionView.reloadData()
//    }
    
}


//MARK: - collection view ішіндегі cell ішіндегі кнопканы басқанда
extension SelleingProdsFirstPageVC: SellingGoodsCellDelegate {
    
    
    func didTappedSellingDeleteButton(sellingProdsCell: SellingProdsCell, id: Int) {
        

        idForDeleting = id
        
        self.ShowAlertControllerWithTwoButtons(deletingGoodID: id)
        self.GoodInBasketApi()
        self.collectionView.reloadData()
      
        
    }
    
    
    func ShowAlertControllerWithTwoButtons(deletingGoodID: Int){
               let alertController = UIAlertController(title: "", message: "Вы точно хотите удалить", preferredStyle: .alert)
               let deleteAction = UIAlertAction(title: "Удалить", style: .default) { (action) in
                self.DeleteGoodFromBasketApi()
                self.update_page_info()
                   
               }
               let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
                   
               }
             
               alertController.addAction(deleteAction)
               alertController.addAction(cancelAction)
               self.present(alertController,animated: true, completion: nil)
        
           }
    
    
    func DeleteGoodFromBasketApi() {

                       do {
                         self.reacibility = try Reachability.init()
                       }

                       catch {
                        // print("unable to start notifier")
                       }

                if ((reacibility!.connection) != .unavailable){
//                                          MBProgressHUD.showAdded(to: self.view, animated: true)

                        //MARK: - Токенді optional түрден String типіне алып келу керек, әйтпесе токен дұрыс жіберілмейді.
                    let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
    //                print("token is \(token)")

                        let headers: HTTPHeaders = [
                            "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                            //"Authorization":"Token 1d61d12c174b38f660f8026bb3d2cc47b5bec66d".trimmingCharacters(in: .whitespacesAndNewlines),
                            "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),

                           ]

                           let encodeURL = basketUrl



//                    print("here is a id for deleting: \(idForDeleting as! Int)")
//                    print(encodeURL+"\(idForDeleting as! Int))/")
//                    print("here starts request to Api")
                    let requestOfApi = AF.request(encodeURL+"\(idForDeleting!)/", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)

                           requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                            
                            self.update_page_info()
                            
//                                                      print(response.request)
//                                                      print(response.result)
//                                                      print(response.response)
                                                      
                    
                                                  })

                       }

                       else{
                           //print("internet is not working")
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                       }

                   }
                
                
    
    func ShowAlertControllerWithOneTextFields(){
            let alertController = UIAlertController(title: "", message: "Введите скидку...", preferredStyle: .alert)
            let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
                
                let percentAlertTextField = alertController.textFields?[0].text
                let percentageInInt = Int(percentAlertTextField?.trimmingCharacters(in: .whitespacesAndNewlines) as! String) as! Int
                
                let  persentaged_cash = self.calculatePercentage(value: self.totalCash, percentage: percentageInInt)
                
                self.sellingTotalPrice.text = "\(persentaged_cash) тенге"
                self.makeSaleButton.setTitle("\(percentageInInt)%", for: .normal)
                self.totalCashAfterPercentaging = persentaged_cash as! Int
                
                print("here is the total cash \(self.totalCashAfterPercentaging)")
    //            print(self.totalCashAfterPersontage)
    //            print(percentAlertTextField)
    //            print(percentageInInt)
                
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
                
            }
            alertController.addTextField { (textfield) in
                textfield.placeholder = "Введите скидку..."
                textfield.keyboardType = .numberPad
                
            }
           
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true, completion: nil)
        }
    
    func CalculateTotalCash(dataFromApi: NSMutableArray){
        
    
        

        totalCash = 0
        for (index, list) in dataFromApi.enumerated() {

            let good = dataFromApi[index] as! NSDictionary
            let goods = good["goods"] as! NSDictionary
            let export_price = goods["export_price"] as! Int
            let goodAmount = good["nums"] as! Int

            totalCash += export_price*goodAmount

        }
//        print("here is the total cash \(totalCash)")
        
        
        
        
        
    }
    
    func send_goods_to_selling_history_api() {
        
//        debug_print(anyObject: totalCashAfterPercentaging)
        
        
        companyIdFromList = UserDefaults.standard.integer(forKey: sellerCompaynuIdIdLocalDB)
        
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
                "company":"\(companyIdFromList)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "sum":"\(totalCashAfterPercentaging)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            let encodeURL = sellingHistoryUrl
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print("here is start response: \(response.request!)")
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
    
    func getTotalSumApi() {
        
        let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
            "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
        ]
        
        let encodeURL = basketUrl
        let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
        requestOfApi.responseJSON(completionHandler: {(response)-> Void in
            
//            print(response.request)
//            print(response.result)
//            print(response.response)
            
            switch response.result {
            case .success(let payload):
                
                let resultValue = payload as! NSArray
                goodsInBasket = NSMutableArray(array: resultValue)
                
                self.CalculateTotalCash(dataFromApi: goodsInBasket)
                self.sellingTotalPrice.text = "\(self.totalCash!)-тенге"
                self.totalCashAfterPercentaging = self.totalCash
            
            case .failure(let _): break
                
            }
            
        })
        
    }
    
    
    func calculatePercentage(value: Int, percentage: Int = 0) -> Int{
        
        var finalValue: Int = 0
        var percentageValue = value * percentage / 100
        
        finalValue = value - percentageValue
        
        return finalValue
    }
    
}






func sumValues(array: Array<Int>) ->Int {
    var sum: Int = 0
    
    for i in array{
        sum += array[i]
    }
    
    return sum
}


func debug_print (message: String, object: Any) {
    print("\(message) : \(object)")
}
