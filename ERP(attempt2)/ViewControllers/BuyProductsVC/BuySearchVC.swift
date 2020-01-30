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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell")
        
        return cell!
    }
    
    
}

extension BuySearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        string = searchText as! String
        getGoodByBarCode()
        
        searching = true
        tableView.reloadData()
    
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
                            
                            debug_print(message: "here is a goodListArray", object: self.goodListArray)
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
