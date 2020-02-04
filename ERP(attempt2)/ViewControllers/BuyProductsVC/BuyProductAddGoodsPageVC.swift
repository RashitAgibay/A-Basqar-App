//
//  BuyProductAddGoodsPageVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/18/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//



//MARK: -Бір категорияны таңдап соны ішіне кірген кезде ашылатын тауарлар беті. 

import UIKit





class BuyProductAddGoodsPageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var idFromCategory: Int = 0
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "userToken"
    var amountFromAlert: String?
    var cashFromAlert: String?
    var goodIdFromVC: Int = 0
    var priceToSendToBuscket: String = "priceToSendToBuscket"
    
    var export_price: String = "0"
    var import_price: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
//        print("here is category id \(idFromCategory)")
        
        
        GoodListApi()
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
        
        //cell.googImageView.layer.cornerRadius = 10
        
        
        
        let good = goodListInfo[indexPath.row] as! NSDictionary
        let goodID = good["id"] as! Int
        let importPrice = good["import_price"] as! Int
        let goods = good["goods"] as! NSDictionary
        let goodName = goods["name"] as! String
        let goodAmount = good["nums"] as! Int
        let catDict = goods["category"] as! NSDictionary
        let catId = catDict["id"] as! Int
        let goodImageUrl = goods["goods_image"] as! String
        
        
//        print("selected id \(catId)")
//        print(idFromCategory)
       // let imageUrl = goods["goods_image"] as! String
        
//        print(goodID)
//        print(importPrice)
//        print(goodName)
//        print(goodAmount)
    
        if goodName != "" {
            cell.nameLabel.text = goodName as! String
        }
        
        cell.balanceLabel.text = "\(goodAmount)"
        cell.cashLabel.text = "\(importPrice) тенге "
        cell.googImageView.sd_setImage(with: URL(string: goodImageUrl), placeholderImage: UIImage(named: "img1"))
    
    
//        if (importPrice) != "" {
//            cell.cashLabel.text = importPrice as! String
//        }
//        if (goodAmount) != "" {
//                   cell.balanceLabel.text = goodAmount as! String
//               }
//

        //cell.googImageView.sd_setImage(with: URL(string: "\(imageUrl)"), placeholderImage: UIImage(named: "img1"))
        
        cell.contentView.layer.cornerRadius = 10
        cell.googImageView.layer.cornerRadius = 5
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let good = goodListInfo[indexPath.row] as! NSDictionary
        let goodID = good["id"] as! Int
        
        
        let goodExportPriceOnSelectedItem = good["export_price"] as! Int
        let goodImportPriceOnSelectedItem = good["import_price"] as! Int
        export_price = "\(goodExportPriceOnSelectedItem)"
        import_price = "\(goodImportPriceOnSelectedItem)"
        
        goodIdFromVC = goodID
        self.ShowAlertControllerWithTwoTextFields()
    }
    
     func GoodListApi() {
                   
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
//                print("token is \(token)")
                    
                    let headers: HTTPHeaders = [
                        "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                        //"Authorization":"Token 1d61d12c174b38f660f8026bb3d2cc47b5bec66d".trimmingCharacters(in: .whitespacesAndNewlines),
                        "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                        
                       ]
                    
//                    let params = [
//
//
//                                  "cat":"\(idFromCategory)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
//
//
//                              ]
                    
                    
                    
                       let encodeURL = goodListUrl
                
                        
                       
                let requestOfApi = AF.request("\(encodeURL)?cat_id=\(idFromCategory)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                       
                       requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                           
//                           print(response.request)
//                           print(response.result)
//                           print(response.response)
                           
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




                                goodListInfo = NSMutableArray(array: resultValue)
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

    
    func SendGoodToBasketApi() {
               
               do {
                 self.reacibility = try Reachability.init()
               }
               
               catch {
                print("unable to start notifier")
                
                
               }
               
               if ((reacibility!.connection) != .none){
                                  MBProgressHUD.showAdded(to: self.view, animated: true)
                   
                
                let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
//                print("token is \(token)")
                    
                    let headers: HTTPHeaders = [
                        "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                        //"Authorization":"Token 1d61d12c174b38f660f8026bb3d2cc47b5bec66d".trimmingCharacters(in: .whitespacesAndNewlines),
                        "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                        
                       ]
                
                
                
                   let params = [
                   
                       
                    "goods":"\(goodIdFromVC)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                       "nums":self.amountFromAlert?.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                       
                       
        
                   ]
                
               
                
                
                
                
                   let encodeURL = buyingBasketURL
                   
                   let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                   
                   requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                       
//                       print(response.request!)
//                       print(response.result)
//                       print(response.response)
                       
//                       switch response.result {
//
//                       case .success(let payload):
//                           MBProgressHUD.hide(for: self.view, animated: true)
//
//                           if let x = payload as? Dictionary<String,AnyObject> {
//                               print(x)
//
//                               let resultValue = x as NSDictionary
//
//
//
//                            //MARK: - (id412) ddictinary ішінде белгілі бір key бар ма жоқ па соны тексеру үшін
//                            if resultValue["error"] != nil {
//                                self.ShowErrorsAlertWithOneCancelButton(message: "Вы ввели логин или пароль не правильно!!!")
//                            }
//
//                            else {
//                                let token = resultValue["token"] as! String
//
//
//                                UserDefaults.standard.set(token, forKey: self.userTokenForUserStandart)
//
//                                print("бұл жерде токен соткада сақталады \(String(describing: UserDefaults.standard.string(forKey: self.userTokenForUserStandart)))")
//                                 self.toTheNextPage()
//                            }
//
//
//
//
//
//                           }
//
//                       case .failure(let error):
//                           print(error)
//                           MBProgressHUD.hide(for: self.view, animated: true)
//                           self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
//
//                       }
                  
                   })
                   
               }
               
               else{
                   print("internet is not working")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
               }
               
           }
    
    func SendGoodsPriceToBasketApi() {
                   
                   do {
                     self.reacibility = try Reachability.init()
                   }
                   
                   catch {
                    print("unable to start notifier")
                    
                    
                   }
                   
                   if ((reacibility!.connection) != .none){
                                      MBProgressHUD.showAdded(to: self.view, animated: true)
                       
                    
                    let token = UserDefaults.standard.string(forKey: self.userTokenForUserStandart) as! String
    //                print("token is \(token)")
                        
                        let headers: HTTPHeaders = [
                            "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                            //"Authorization":"Token 1d61d12c174b38f660f8026bb3d2cc47b5bec66d".trimmingCharacters(in: .whitespacesAndNewlines),
                            "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                            
                           ]
                    
                    
                    
                       let params = [
                       
                           
                        "export_price":export_price.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                           "import_price":import_price.trimmingCharacters(in: .whitespacesAndNewlines) as! String,
                           
                           
            
                       ]
                    
                   
                    
                    
                    
                    
                       let encodeURL = goodListUrl
                       
                       let requestOfApi = AF.request(encodeURL + "\(goodIdFromVC)/", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                       
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
    
    
    //MARK: - (id_456143) Сатып алуда тауарды корзинаға қосу
    func ShowAlertControllerWithTwoTextFields(){
        let alertController = UIAlertController(title: "", message: "Введите количество...", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            
            
            let amountAlertTextField = alertController.textFields?[0].text
            let cashAlertTextField  = alertController.textFields?[1].text
            self.import_price = cashAlertTextField as! String
            
            

            
            if amountAlertTextField != "" {
                self.amountFromAlert = amountAlertTextField
            }

            else {
                self.amountFromAlert = "1"
            }
            
                
            self.cashFromAlert = cashAlertTextField
            self.priceToSendToBuscket = cashAlertTextField as! String
            
            self.SendGoodToBasketApi()
            self.SendGoodsPriceToBasketApi()
            self.goToTheBackPAge()
            
            
            
            
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "1"
            textfield.keyboardType = .numberPad
//            textfield.text = "1"
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "\(self.import_price)"
            textfield.keyboardType = .numberPad
//            textfield.text = self.import_price
            
        }
        
        
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
    func goToTheBackPAge() {
//        print(self.amountFromAlert)
//        print(self.cashFromAlert)
//        print("it is id of good: \(goodIdFromVC)")
        performSegue(withIdentifier: "goodChoosen", sender: self)
        //print("tapped add button in alert")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goodChoosen" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? BuyProductVC {
                targetController.goodPriceInBuscket = priceToSendToBuscket
            }
        }
    }
    
    

}

