//
//  ProductNetworkManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 05.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol ProductNetworkable {
    
    var provider: MoyaProvider<ProductApi> { get }
    
    func getFirstLevelCats(completion: @escaping ([FirstLevelCat]?, Error?) -> ())
    func getExactCatProds(catId: Int, completion: @escaping ([StoreProduct]?, Error?) -> ())
    func editPrices(prodId: Int, editingPrices: EditingProductPrices, completion: @escaping (CommonApiResponse?, Error?) -> ())
}

class ProductNetworkManager: ProductNetworkable {
    
    public static let service = ProductNetworkManager()
    
    var provider = MoyaProvider<ProductApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getFirstLevelCats(completion: @escaping ([FirstLevelCat]?, Error?) -> ()) {
        provider.request(.getFirstLevelCats) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let categories = try decoder.decode([FirstLevelCat].self, from: response.data)
                    completion(categories, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getExactCatProds(catId: Int, completion: @escaping ([StoreProduct]?, Error?) -> ()) {
        provider.request(.getExactCatProds(catId: catId)) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let prods = try decoder.decode([StoreProduct].self, from: response.data)
                    completion(prods, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func editPrices(prodId: Int, editingPrices: EditingProductPrices, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.editPrices(prodId: prodId, editingProdPrices: editingPrices)) { (result) in
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
