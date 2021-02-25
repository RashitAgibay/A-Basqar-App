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
    case addProdToCard(addingMovementProd: AddingMovementProd)
    case editCartProdCount(editingMovementProd: EditingMovementProd)
    case deleteCartProd(deleteCartProd: DeletingMovementProd)
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
        case .editCartProdCount:
            return EndPoint.Movement.editProdCount
        case .deleteCartProd:
            return EndPoint.Movement.deleteProd
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
        case .editCartProdCount:
            return .put
        case .deleteCartProd:
            return .delete
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
        case .editCartProdCount(let editingMovementProd):
            return .requestJSONEncodable(editingMovementProd)
        case .deleteCartProd(let deleteCartProd):
            return .requestJSONEncodable(deleteCartProd)
        }
    }
}
