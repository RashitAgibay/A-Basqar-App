//
//  AuthApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 26.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Moya

enum AuthApi {
    case login(userInfo: UserInfo)
}

extension AuthApi: TargetType {
    var baseURL: URL {
        #if DEBUG
        guard let url = URL(string: "http://127.0.0.1:8000") else {
            fatalError()
        }
        return url
        #else
        guard let url = URL(string: "") else {
            fatalError()
        }
        return url
        #endif
    }
    
    var path: String {
        switch self {
        case .login:
            return EndPoint.shared.getLoginEndPoint()
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    
    var task: Task {
        switch self {
        case .login(let userInfo):
            return .requestJSONEncodable(userInfo)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return ["Content-type": "application/json; charset=UTF-8"]
        }
    }
}
