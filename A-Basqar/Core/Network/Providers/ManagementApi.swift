//
//  ManagementApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 15.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum ManagementApi {
    case getContrList
}

extension ManagementApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getContrList:
            return EndPoint.Managment.contList
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getContrList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getContrList:
            return .requestPlain
        }
    }
    
    
}
