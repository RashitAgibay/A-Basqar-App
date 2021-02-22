//
//  ManagementNetworkManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 15.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol ManagementNetworkable {
    var provider: MoyaProvider<ManagementApi> { get }
    
    func getContrList(completion: @escaping ([Contragent]?, Error?) -> ())
    func createNewContr(contr: ContrSending, completion: @escaping (CommonApiResponse?, Error?) -> ())
    func editContrInfo(contr: ContrSending, completion: @escaping (CommonApiResponse?, Error?) -> ())
    func getUserStore(comletion: @escaping ([Store]?, Error?) -> ())
    func getCompanyAllUsers(completion: @escaping ([UserProfile]?, Error?) -> ())
    func getExactStoreUsers(storeId: Int, completion: @escaping ([UserProfile]?, Error?) -> ())
}

class ManagementNetworkManager: ManagementNetworkable {
    public static let service = ManagementNetworkManager()
    var provider = MoyaProvider<ManagementApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getUserStore(comletion: @escaping ([Store]?, Error?) -> ()) {
        provider.request(.getUserStores) { (result) in
            switch result {
            case .success(let response):
                do {
                    let stores = try JSONDecoder().decode([Store].self, from: response.data)
                    comletion(stores, nil)
                }
                catch let error {
                    comletion(nil, error)
                }
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }

    func getContrList(completion: @escaping ([Contragent]?, Error?) -> ()) {
        provider.request(.getContrList) { (result) in
            switch result {
            case .success(let response):
                do {
                    let contrs = try JSONDecoder().decode([Contragent].self, from: response.data)
                    completion(contrs, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func createNewContr(contr: ContrSending, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.createNewContr(contr: contr)) { (result) in
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
    
    func editContrInfo(contr: ContrSending, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.editContrData(contr: contr)) { (result) in
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
    
    func getCompanyAllUsers(completion: @escaping ([UserProfile]?, Error?) -> ()) {
        provider.request(.getCompanyUsers) { (result) in
            switch result {
            case .success(let response):
                do {
                    let users = try JSONDecoder().decode([UserProfile].self, from: response.data)
                    completion(users, nil)
                }
                catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getExactStoreUsers(storeId: Int, completion: @escaping ([UserProfile]?, Error?) -> ()) {
        provider.request(.getExactStoreUser(storeId: storeId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let users = try JSONDecoder().decode([UserProfile].self, from: response.data)
                    completion(users, nil)
                }
                catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
