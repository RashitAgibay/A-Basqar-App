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

extension AuthApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .login:
            return EndPoint.Auth.login
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let userInfo):
            return .requestJSONEncodable(userInfo)
        }
    }
}
