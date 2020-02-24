//
//  AddProdToSellingPageVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit


public var sellerCompanyNameInLocalDB: String = "sellerCompanyNameInLocalDB"
public var sellerCompaynuIdIdLocalDB:String = "sellerCompaynuIdIdLocalDB"

//MARK: - Покупательдер тізімі
class AddProdToSellingPageVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reacibility: Reachability?
    var userTokenForUserStandart: String = "userToken"
    
    var companyNameInList: String = "Покупатель..."
    var companyID: Int = 0
    
    
    let refreshControl: UIRefreshControl = {
        
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refControl
       }()
    
    @objc private func refreshData(sender: UIRefreshControl){
    GetBuyerCompaniesApi()
    sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = refreshControl
        GetBuyerCompaniesApi()
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return buyerListDataInfo.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellerCell", for: indexPath) as! AddProdToSellingPageCell
           
           cell.contentView.layer.cornerRadius = 10
           cell.layer.shadowColor = UIColor.gray.cgColor
           cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
           cell.layer.shadowOpacity = 0.5
           cell.layer.masksToBounds = false
           cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
           
           
          let companiesData = buyerListDataInfo[indexPath.row] as! NSDictionary

          let companyName = companiesData["company_name"] as! String
          let companyId = companiesData["id"] as! Int
           
           cell.sellingCompanyName.text = companyName
           
           //MARK: - (id - 15647)
//           cell.sellingChangeButton.addTarget(self, action: #selector(toTheNextViewFromButtonInTheCell), for: .touchUpInside)
           

           return cell
       }

    //MARK: - Компаниялар тізімінен біреуінің атын сату корзинасына жіберу үшін
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "tomainpagefrombuyerlist" {
                if let destVC = segue.destination as? UINavigationController,
                    let targetController = destVC.topViewController as? SellingProdVC {
                    targetController.companyNameBuyProductVC = companyNameInList
                    targetController.company_id = companyID
                }
            }
        }
        //MARK: - Компаниялар тізімінен біреуінің атын сату корзинасына жіберу үшін
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let companiesData = buyerListDataInfo[indexPath.row] as! NSDictionary

            companyNameInList = companiesData["company_name"] as! String
            companyID = companiesData["id"] as! Int
            
            UserDefaults.standard.set(companyNameInList, forKey: sellerCompanyNameInLocalDB)
            UserDefaults.standard.set(companyID, forKey: sellerCompaynuIdIdLocalDB)
            
    //        PassCompanyNameToTheBasket(data: companyNameInList)
            
    //        print("here is company name in BuyerCompanyVC: \(companyNameInList)")
            performSegue(withIdentifier: "tomainpagefrombuyerlist", sender: self)
         
        }
    
    
    func GetBuyerCompaniesApi() {
                           
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
                            
              
                            
                               let encodeURL = buyerCompaniesUrl
                        
                                
                               
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
                                        // print(resultValue)


                                        buyerListDataInfo = NSMutableArray(array: resultValue)
                                        self.collectionView.reloadData()

    //                                    print("осы жерде company инфо")
    //                                    print(self.buyerListDataInfo)

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
    
}





