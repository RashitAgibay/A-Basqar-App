//
//  BuyProductVCFirstPage.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/26/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class BuyProductVCFirstPage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var companyName: UIButton!
    @IBOutlet weak var salePercentText: UITextField!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var makeSaleButton: UIButton!
    
    
    
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "userToken"
    var companyNameFromList: String = "companyNameFromList"
    var goodPriceFromList: String = "goodPriceFromList"
    var eachPrices: String = "eachPrices"
    var idForDeleting: Int!
    var totalCash: Int = 0
    var percentage: Int = 0
    var totalCashAfterPersontage: Int = 0
    var companyIdFromList: Int = 0
    
    var barcode_from_main  = String()
    
//    let buyProductVC = BuyProductVC()
//    let buyerCompanyVC = BuyerCompanyVC()
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
    }()

    @objc private func refreshData(sender: UIRefreshControl){
        updatePageInfo()
        sender.endRefreshing()
        }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        toTestVarcode()
        
        //MARK: - страница новой покупки
//        print(" страница новой покупки ")
        
        
//        companyNameFromList = buyerCompanyVC.companyNameInList
//        print("into the internal view card: \(companyNameFromList)")
//        print("\(goodPriceFromList) in BuyProductVCFirstPage")
        
        collectionView.refreshControl = refreshControl
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        
        cardView.layer.cornerRadius = 10
        cardView.dropShadow()
        cardView.layer.backgroundColor = UIColor.white.cgColor

        sellButton.layer.cornerRadius = 10
        sellButton.dropShadowforButton()
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.dropShadowforButton()
        
        companyName.layer.cornerRadius = 5
        companyName.dropShadowforButton()
        companyName.setTitle(companyNameFromList, for: .normal)
       
        makeSaleButton.layer.cornerRadius = 5
        makeSaleButton.dropShadowforButton()
        makeSaleButton.setTitle("\(percentage)%", for: .normal)
        
        
        self.totalPrice.text = "0"
        updatePageInfo()
        
//         print("here is a company id \(companyIdFromList)")
        
//        NotificationCenter.default.addObserver(self, selector: #selector(gotNitification(notification:)), name: NSNotification.Name(rawValue: "notoficationFromCompaniesList"), object: nil)
        
//        print("here is the companyIdFromList \(companyIdFromList)")
        
        
//        priceInBusket.add(goodPriceFromList)
//        companyNameInBusket.add(companyNameFromList)
        
//        print("array \(priceInBusket[1])")
//        print("array \(companyNameInBusket[1])")
        
    }
    
//    @objc func gotNitification(notification: Notification) {
//
//        guard let userInfo = notification.userInfo  else {
//            return
//        }
//
//        guard let companiesID = userInfo["companyId"] as? Int else {
//            return
//        }
//
//        companyIdFromList = companiesID
//        print("here is the companyIdFromList \(companyIdFromList)")
////        print("here is the got not \(companiesID)")
//
//    }
    
    func updatePageInfo(){
        GoodInBasketApi()
        getTotalSumApi()
        self.collectionView.reloadData()
    }

    @IBAction func tappedMakeSaleButton(_ sender: Any) {
        ShowAlertControllerWithOneTextFields()
    }
    
    
    func toTestVarcode(){
        debug_print(message: "here is a bar code in BuyProductVCFirstPage's test function ", object: barcode_from_main)
        ShowErrorsAlertWithOneCancelButton(message: barcode_from_main)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsInBasket.count
       }
       
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buyProduct", for: indexPath) as! BuyProductFirstPageCell
        let totalPriceOfGood: Int
        
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        cell.pricesCard.layer.cornerRadius=10
        cell.pricesCard.layer.backgroundColor = UIColor.white.cgColor
        cell.pricesCard.layer.borderWidth = 1
        cell.pricesCard.layer.borderColor = hexStringToUIColor(hex: "#3F639D").cgColor
        
        cell.cellImageView.layer.cornerRadius = 10
        
        
        
        let good = goodsInBasket[indexPath.row] as! NSDictionary
        
        let goodCardID = good["id"] as! Int
        let goods = good["goods"] as! NSDictionary
        let goodAmount = good["nums"] as! Int
        
        
        let totalBalance = goods["nums"] as! Int // Общий остаток товара в складе
        let import_price = goods["import_price"] as! Int
        
        
        let eachgoods = goods["goods"] as! NSDictionary // Словарь для каждого товара
        
        let goodID = eachgoods["id"] as! Int
        let goodBarCode = eachgoods["goods_sn"] as! String
        
        let goodName = eachgoods["name"] as! String
        let goodImageUrl = eachgoods["goods_image"] as! String
        
        totalPriceOfGood = import_price * goodAmount
        
//        print("название: \(goodName)")
//        print("остаток: \(totalBalance)")
//        print("цена: \(import_price)")
//        print("количество: \(goodAmount)")
//        print("общая сумма: \(totalPriceOfGood)")
        cell.idOfGood = goodCardID
        cell.delegate = self
        
       
        cell.nameOfProduct.text = goodName
        cell.balanceLabel.text = "\(totalBalance)"
        cell.priceLabel.text = "\(import_price)-тг "
        cell.amountLabel.text = "\(goodAmount)"
        cell.totalPriceText.text = "\(totalPriceOfGood)-тг "
        
        cell.cellImageView.sd_setImage(with: URL(string: goodImageUrl), placeholderImage: UIImage(named: "img1"))
        
        

        
        
        
        
        return cell
        
    }
    
    @IBAction func tapCompanyNameButton(_ sender: Any) {
    }
    
    @IBAction func tapSellButton(_ sender: Any) {
        
        if companyNameFromList != "Контрагент..." {
            SendGoodsToBuyingHistory()
            performSegue(withIdentifier: "tobuyingkassapagefrombuying", sender: self)
        }
        else {
            ShowErrorsAlertWithOneCancelButton(message: "Выберите контрагента...")
        }
        
        
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
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
                                     
                           let encodeURL = buyingBasketURL
                  
                    let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                           
                           requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                               
//                               print(response.request)
//                               print(response.result)
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
                                    self.collectionView.reloadData()

//                                    print("here is a \(goodsInBasket.reversed())")
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

                               let encodeURL = buyingBasketURL



    //                    print("here is a id for deleting: \(idForDeleting as! Int)")
    //                    print(encodeURL+"\(idForDeleting as! Int))/")
    //                    print("here starts request to Api")
                        let requestOfApi = AF.request(encodeURL+"\(idForDeleting!)/", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)

                               requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                                                          
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
}

extension BuyProductVCFirstPage: BuyingGoodsCellDelegate {
    
    func didTappedBuyingDeleteButton(buyingProdsCell: BuyProductFirstPageCell, id: Int) {
        
//        print("it is work")
        idForDeleting = id
        
        self.ShowAlertControllerWithTwoButtons(deletingGoodID: id)
    }
    
    func ShowAlertControllerWithTwoButtons(deletingGoodID: Int){
           let alertController = UIAlertController(title: "", message: "Вы точно хотите удалить ", preferredStyle: .alert)
           let deleteAction = UIAlertAction(title: "Удалить", style: .default) { (action) in
           
            DispatchQueue.background(background: {
                self.DeleteGoodFromBasketApi()
            }, completion: {
//                when background job finished, do something in main thread
            })
            
            
            self.updatePageInfo()
           
            
               
           }
           let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
               
           }
         
           alertController.addAction(deleteAction)
           alertController.addAction(cancelAction)
           self.present(alertController,animated: true, completion: nil)
    
       }
    
    func getTotalSumApi() {
        
        let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
            "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
        ]
        
        let encodeURL = buyingBasketURL
        let requestOfApi = AF.request(encodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
        requestOfApi.responseJSON(completionHandler: {(response)-> Void in
            
    //        print(response.request)
    //        print(response.result)
    //        print(response.response)
            
            switch response.result {
            case .success(let payload):
                

                    let resultValue = payload as! NSArray
                    goodsInBasket = NSMutableArray(array: resultValue)
                    
                   
                        
                    self.totalCash = self.CalculateTotalCash(dataFromApi: goodsInBasket)
                    self.totalCashAfterPersontage = self.totalCash
                    
                    
                    self.totalPrice.text = "\(self.totalCash) тенге "
//                    print("here is the total cash \(self.totalCash)")
                        
      
            case .failure(let _): break
                
            }
            
        })
        
    }
    
    func CalculateTotalCash(dataFromApi: NSMutableArray) -> Int {
        
        var totalImportCash = 0
        
        for (index, list) in dataFromApi.enumerated() {

            let good = dataFromApi[index] as! NSDictionary
            let goods = good["goods"] as! NSDictionary
            let import_price = goods["import_price"] as! Int
            let goodAmount = good["nums"] as! Int

            totalImportCash += import_price*goodAmount

        }
        
        return totalImportCash
    }
    
    func calculatePercentage(value: Int, percentage: Int = 0) -> Int{
        
        var finalValue: Int = 0
        var percentageValue = value * percentage / 100
        
        finalValue = value - percentageValue
        
        return finalValue
    }
    
    func ShowAlertControllerWithOneTextFields(){
        let alertController = UIAlertController(title: "", message: "Введите скидку...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            let percentAlertTextField = alertController.textFields?[0].text
            let percentageInInt = Int(percentAlertTextField?.trimmingCharacters(in: .whitespacesAndNewlines) as! String) as! Int
            
            let  persentaged_cash = self.calculatePercentage(value: self.totalCash, percentage: percentageInInt)
            
            self.totalPrice.text = "\(persentaged_cash) тенге"
            self.makeSaleButton.setTitle("\(percentageInInt)%", for: .normal)
            self.totalCashAfterPersontage = persentaged_cash
            
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
    
    func SendGoodsToBuyingHistory() {
                   
                   do {
                     self.reacibility = try Reachability.init()
                   }
                   
                   catch {
                    print("unable to start notifier")
                    
                    
                   }
                   
                   if ((reacibility!.connection) != .none){
                                      MBProgressHUD.showAdded(to: self.view, animated: true)
                       
                    let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
                        
                    let headers: HTTPHeaders = [
                            "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                            "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                           ]
                    
                    let params = [
                        "company":"\(companyIdFromList)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                        "sum":"\(totalCashAfterPersontage)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                       ]
                    
                    let encodeURL = buyingHistoryUrl
                    let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                       
                       requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                           
//                           print(response.request!)
//                           print(response.result)
//                           print(response.response)
                           
                       })
                       
                   }
                   
                   else{
                       print("internet is not working")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
                   }
                   
               }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
