//
//  ImportNetworkManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 01.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol ImportNetworkable {
    
    var provider: MoyaProvider<ImportApi> { get }

    func checkCart(completion: @escaping (CommonImportApiResponse?, Error?) -> ())
    func getCurrentCart(comletion: @escaping (ImportCart?, Error?) -> ())
    func createNewCart(completion: @escaping (CommonImportApiResponse?, Error?) -> ())
    func addProdsToCart(product: AddingImportProd, comletion: @escaping (CommonImportApiResponse?, Error?) -> ())
    func editProdAmount(editImportProd: EditingImportProd, completion: @escaping (CommonApiResponse?, Error?) -> ())
    func getHistory(completion: @escaping ([ImportCartObject]?, Error?) -> ())
    func getHistoryItem(historyId:Int, completion: @escaping (ImportCart?, Error?) -> ())

}

class ImportNetworkManager: ImportNetworkable {
    
    public static let service = ImportNetworkManager()
    var provider = MoyaProvider<ImportApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    
    func checkCart(completion: @escaping (CommonImportApiResponse?, Error?) -> ()) {
//        provider.request(.checkCurrentCart, completion: <#T##Completion##Completion##(Result<Response, MoyaError>) -> Void#>)
    }
    
    func getCurrentCart(comletion: @escaping (ImportCart?, Error?) -> ()) {
        provider.request(.getCurrentCart) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let currentCart = try decoder.decode(ImportCart.self, from: response.data)
                    comletion(currentCart, nil)
                }
                catch let error {
                    comletion(nil, error)
                }
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func createNewCart(completion: @escaping (CommonImportApiResponse?, Error?) -> ()) {
        provider.request(.createNewCart) { (reslut) in
            switch reslut {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let message = try decoder.decode(CommonImportApiResponse.self, from: response.data)
                    completion(message, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func addProdsToCart(product: AddingImportProd, comletion: @escaping (CommonImportApiResponse?, Error?) -> ()) {
        provider.request(.addProdsToCart(addingProd: product)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonImportApiResponse.self, from: response.data)
                    comletion(message, nil)
                }
                catch let error {
                    comletion(nil, error)
                }
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func editProdAmount(editImportProd: EditingImportProd, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.editProdInCart(edititngProd: editImportProd)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonApiResponse.self, from: response.data)
                    completion(message, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func deleteProdInCart(deletingProdId: Int, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.deleteProdInCart(deletingProd: DeletingImportProd(product_id: deletingProdId))) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try
                        JSONDecoder().decode(CommonApiResponse.self, from: response.data)
                    completion(message, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getHistory(completion: @escaping ([ImportCartObject]?, Error?) -> ()) {
        provider.request(.getImportHistory) { (result) in
            switch result {
            case .success(let response):
                do {
                    let history = try JSONDecoder().decode([ImportCartObject].self, from: response.data)
                    completion(history, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getHistoryItem(historyId: Int,completion: @escaping (ImportCart?, Error?) -> ()) {
        provider.request(.getImportHistoryItem(historyItem: historyId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let history = try JSONDecoder().decode(ImportCart.self, from: response.data)
                    completion(history, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
