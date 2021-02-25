//
//  MovementApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 24.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum MovementApi {
    case getCurrentCart
    case createNewCartObject
    case addProdToCard(addingMovemetProd: AddingMovementProd)
}

extension MovementApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getCurrentCart:
            return EndPoint.Movement.getCurrentCart
        case .createNewCartObject:
            return EndPoint.Movement.createNewCart
        case .addProdToCard:
            return EndPoint.Movement.addProdsToCart
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrentCart:
            return .get
        case .createNewCartObject:
            return .post
        case .addProdToCard:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCurrentCart:
            return .requestPlain
        case .createNewCartObject:
            return .requestPlain
        case .addProdToCard(let addingMovemetProd):
            return .requestJSONEncodable(addingMovemetProd)
        }
    }
}
