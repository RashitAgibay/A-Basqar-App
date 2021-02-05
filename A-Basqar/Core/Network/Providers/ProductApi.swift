//
//  ProductsApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 05.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum ProductApi {
    case getFirstLevelCats
}

extension ProductApi: BaseApiDelegate {
    
    var path: String {
        switch self {
        case .getFirstLevelCats:
            return EndPoint.Product.firstLevetCat
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFirstLevelCats:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getFirstLevelCats:
            return .requestPlain
        }
    }
}
