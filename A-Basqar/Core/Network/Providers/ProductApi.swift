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
    case getExactCatProds(catId: Int)
}

extension ProductApi: BaseApiDelegate {
    
    var path: String {
        switch self {
        case .getFirstLevelCats:
            return EndPoint.Product.firstLevelCat
        case .getExactCatProds(let catId):
            return EndPoint.Product.exactCatprods + "\(catId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFirstLevelCats:
            return .get
        case .getExactCatProds:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getFirstLevelCats:
            return .requestPlain
        case .getExactCatProds:
            return .requestPlain
        }
    }
}
