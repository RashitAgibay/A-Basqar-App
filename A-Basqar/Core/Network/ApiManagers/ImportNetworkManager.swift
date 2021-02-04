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
//    func createNewCart(completion: @escaping () -> ())
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
}
