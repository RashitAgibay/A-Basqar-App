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
}
