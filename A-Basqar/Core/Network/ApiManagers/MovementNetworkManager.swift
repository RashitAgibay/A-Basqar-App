//
//  MovementNetworkManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 24.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol MovementNetworkable {
    var provider: MoyaProvider<MovementApi> { get }
    
    func getCurrentCart(completion: @escaping (MovementCart?, Error?) -> ())
    func createNewCartObject(completion: @escaping (CommonMovementResponse?, Error?) -> ())
    func addProdToCart(addingProd: AddingMovementProd, completion: @escaping (CommonMovementResponse?, Error?) -> ())
    func editCartProdCount(editingCartProd: EditingMovementProd, completion: @escaping (CommonMovementResponse?, Error?) -> ())
}

class MovementNetworkManager: MovementNetworkable {
    public static let service = MovementNetworkManager()
    var provider = MoyaProvider<MovementApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getCurrentCart(completion: @escaping (MovementCart?, Error?) -> ()) {
        provider.request(.getCurrentCart) { (result) in
            switch result {
            case .success(let response):
                do {
                    let cart = try JSONDecoder().decode(MovementCart.self, from: response.data)
                    completion(cart, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func createNewCartObject(completion: @escaping (CommonMovementResponse?, Error?) -> ()) {
        provider.request(.createNewCartObject) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonMovementResponse.self, from: response.data)
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
    
    func addProdToCart(addingProd: AddingMovementProd, completion: @escaping (CommonMovementResponse?, Error?) -> ()) {
        provider.request(.addProdToCard(addingMovementProd: addingProd)) { (reslut) in
            switch reslut {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonMovementResponse.self, from: response.data)
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
    
    func editCartProdCount(editingCartProd: EditingMovementProd, completion: @escaping (CommonMovementResponse?, Error?) -> ()) {
        provider.request(.editCartProdCount(editingMovementProd: editingCartProd)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonMovementResponse.self, from: response.data)
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
