//
//  ExportNetworkManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 15.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol ExportNetworkable {
    
    var provider: MoyaProvider<ExportApi> { get }

    func getCurrentCart(comletion: @escaping (ExportCart?, Error?) -> ())
    func createNewCart(completion: @escaping (CommonExportApiResponse?, Error?) -> ())
    func addProdsToCart(product: AddingExportProd, comletion: @escaping (CommonExportApiResponse?, Error?) -> ())
    func editProdAmount(editExportProd: EditingExportProd, completion: @escaping (CommonApiResponse?, Error?) -> ())
    func getHistory(completion: @escaping ([ExportCartObject]?, Error?) -> ())
    func getHistoryItem(historyId:Int, completion: @escaping (ExportCart?, Error?) -> ())
    func makeHistory(cartObject: ExportCartModel, completion: @escaping (CommonApiResponse?, Error?) -> ())
}


class ExportNetworkManager: ExportNetworkable {
    
    public static let service = ExportNetworkManager()
    var provider = MoyaProvider<ExportApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getCurrentCart(comletion: @escaping (ExportCart?, Error?) -> ()) {
        provider.request(.getCurrentCart) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let currentCart = try decoder.decode(ExportCart.self, from: response.data)
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
    
    func createNewCart(completion: @escaping (CommonExportApiResponse?, Error?) -> ()) {
        provider.request(.createNewCart) { (reslut) in
            switch reslut {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let message = try decoder.decode(CommonExportApiResponse.self, from: response.data)
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
    
    func addProdsToCart(product: AddingExportProd, comletion: @escaping (CommonExportApiResponse?, Error?) -> ()) {
        provider.request(.addProdsToCart(addingProd: product)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonExportApiResponse.self, from: response.data)
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
    
    func editProdAmount(editExportProd: EditingExportProd, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.editProdInCart(edititngProd: editExportProd)) { (result) in
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
        provider.request(.deleteProdInCart(deletingProd: DeletingExportProd(product_id: deletingProdId))) { (result) in
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
    
    func getHistory(completion: @escaping ([ExportCartObject]?, Error?) -> ()) {
        provider.request(.getExportHistory) { (result) in
            switch result {
            case .success(let response):
                do {
                    let history = try JSONDecoder().decode([ExportCartObject].self, from: response.data)
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
    
    func getHistoryItem(historyId: Int,completion: @escaping (ExportCart?, Error?) -> ()) {
        provider.request(.getExportHistoryItem(historyItem: historyId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let history = try JSONDecoder().decode(ExportCart.self, from: response.data)
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
    
    func makeHistory(cartObject: ExportCartModel, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.makeExportHistory(exportCart: cartObject)) { (result) in
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
}
