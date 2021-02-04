//
//  AuthApiService.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 27.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol AuthNetworkable {
    var provider: MoyaProvider<AuthApi> { get }
    
    func login(userInfo: UserInfo, completion: @escaping (Token?, Error?) -> ())
}

class AuthNetworkManager: AuthNetworkable {
    var provider = MoyaProvider<AuthApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])

    func login(userInfo: UserInfo, completion: @escaping (Token?, Error?) -> ()) {
        provider.request(.login(userInfo: userInfo)) { (response) in
            switch response {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let token = try decoder.decode(Token.self, from: value.data)
                    completion(token, nil)
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
