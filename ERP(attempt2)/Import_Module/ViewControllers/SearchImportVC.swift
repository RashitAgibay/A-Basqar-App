//
//  SearchImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/8/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class SearchImportVC: DefaultVC {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var productArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func tappedBackButton(_ sender: Any) {
        
        self.navigateToMainImport()
    }
        
}

extension SearchImportVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchImportCell")
        
//        print(goodListArray)
        
        let eachGood = productArray[indexPath.row] as! NSDictionary
        let goods = eachGood["goods"] as! NSDictionary
        
        let goodName = goods["name"] as! String
        
        cell?.textLabel?.text = goodName
        
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eachGood = productArray[indexPath.row] as! NSDictionary
        
        let id = eachGood["id"] as! Int
        
        self.sendGoodToBasket(productID: id, amount: "1")
        
        self.navigateToMainImport()
    }
}

extension SearchImportVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let string = searchText as! String

        self.getProductsBySearching(string: string)
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}

extension SearchImportVC {
    
    func getProductsBySearching(string: String) {
        
        do {
            
            reacibility = try Reachability.init()
        }
        
        catch {
        
        }
        
        if ((reacibility?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let encodeURL = productListUrl
            
            let allowedURL = (encodeURL + "?goods_name=\(string)").addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)!
            
            let requestOfApi = AF.request(allowedURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request)
//                print(response.result)
//                print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                        
                        let resultValue = x["results"] as! NSArray
                        self.productArray = resultValue
                        self.tableView.reloadData()
                    }
                    
                    else {
                        
//                        let resultValue = payload as! NSArray
//                        self.goodListArray = NSMutableArray(array: resultValue)
//
//                        self.tableView.reloadData()
                    }
                
                case .failure(let error):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")}
            })
        }
        
        else {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    private func sendGoodToBasket(productID: Int, amount: String) {
        
        do {
            
            self.reachability = try Reachability.init()
        }
        
        catch {
            
            print("unable to start notifier")
        
        }
        
        if ((reacibility?.connection) != .unavailable) {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String
            
            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let params = [
                
                "goods":"\(productID)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "nums":"\(amount)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            let encodeURL = importShoppingCartURL
            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
                MBProgressHUD.hide(for: self.view, animated: true)

//                print(response.request!)
//                print(response.result)
//                print(response.response)
            })
        }
            
        else {
            
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
}

extension SearchImportVC {
    
    private func navigateToMainImport() {
        
        performSegue(withIdentifier: "fromSearchProdsToMainImport", sender: self)
    }
}

