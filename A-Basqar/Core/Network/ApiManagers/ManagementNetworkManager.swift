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
}

class ManagementNetworkManager: ManagementNetworkable {
    public static let service = ManagementNetworkManager()
    var provider = MoyaProvider<ManagementApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])

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
}
