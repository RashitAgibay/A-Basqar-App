//
//  BuySearchVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 1/30/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class BuySearchVC: UIViewController {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searching = false
    var goodListArray = NSArray()
    var string = String()
    var goodID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

              
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BuySearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell")
        
        let eachGood = goodListArray[indexPath.row] as! NSDictionary
        let goods = eachGood["goods"] as! NSDictionary
        
        let goodName = goods["name"] as! String
        
        cell?.textLabel?.text = goodName
        
        return cell!
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eachGood = goodListArray[indexPath.row] as! NSDictionary
        
        
        let id = eachGood["id"] as! Int
        self.goodID = id
        
//        debug_print(message: "here is an id", object: id)
        
        SendGoodToBasketApi()
        
        performSegue(withIdentifier: "afterselectedgoodfromsearch", sender: self)
    }
    
}

extension BuySearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        string = searchText as! String
        getGoodByBarCode()
        
        searching = true
        
    
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}

extension BuySearchVC {
    
    func getGoodByBarCode() {
            
            do {
                reacibility = try Reachability.init()
            }
            
            catch {
            
            }
            
            if ((reacibility!.connection) != .unavailable){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                    "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
                ]
                
                let encodeURL = goodListUrl
                
                //MARK: -api ға запрос жібергенде кирилиццамен жіберуге мүмкіндік болу үшін
                let allowedURL = (encodeURL + "?goods_name=\(string)").addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)!
                
                let requestOfApi = AF.request(allowedURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
                requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                    
//                    print(response.request)
//                    print(response.result)
//                    print(response.response)
                    
                    switch response.result {
                    
                    case .success(let payload):
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        if let x = payload as? Dictionary<String,AnyObject> {
                            
    //                        print(x)
                        }
                        else {
                            
                            let resultValue = payload as! NSArray
                            self.goodListArray = NSMutableArray(array: resultValue)
                            
//                            let good = self.goodListArray[0] as! NSDictionary
//                            self.goodID = good["id"] as! Int
                            
//                            self.SendGoodToBasketApi()
                            
//                            debug_print(message: "here is a goodListArray", object: self.goodListArray)
                            
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        
                        print(error)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.ShowErrorsAlertWithOneCancelButton(message: "URL-ға запроста  да бірдеңе дұрыс емес")}
                })
            
            }
            
            else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
            }
        }
    
    
    func SendGoodToBasketApi() {
        
        do {
            reacibility = try Reachability.init()
        }
        catch {
            print("unable to start notifier")
        }
        
        if ((reacibility!.connection) != .none){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenForUserStandart) as! String
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"Token \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let params = [
                
                "goods":"\(self.goodID)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "nums":"\(1)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            
            let encodeURL = buyingBasketURL
            
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                print(response.request!)
                print(response.result)
                print(response.response)
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
