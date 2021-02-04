//
//  ImportApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 01.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum ImportApi {
    case checkCurrentCart
    case getCurrentCart
    case createNewCart
    case addProdsToCart(addingProd: AddingImportProd)
    case editProdInCart(edititngProd: EditingImportProd)
    case deleteProdInCart(deletingProd: DeletingImportProd)
    case getImportHistory
    case getImportHistoryItem(historyItem: Int)
    case makeImportHistory(importCart: ImportCartModel)
}

extension ImportApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .checkCurrentCart:
            return EndPoint.Import.checkCart
        case .getCurrentCart:
            return EndPoint.Import.getCart
        case .createNewCart:
            return EndPoint.Import.createNewCart
        case .addProdsToCart:
            return EndPoint.Import.addProdToCart
        case .editProdInCart:
            return EndPoint.Import.editCartProd
        case .deleteProdInCart:
            return EndPoint.Import.deleteCartProd
        case .getImportHistory:
            return EndPoint.Import.history
        case .getImportHistoryItem(let historyItem):
            return EndPoint.Import.historyItem + "\(historyItem)"
        case .makeImportHistory:
            return EndPoint.Import.makeHistory
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkCurrentCart:
            return .get
        case .getCurrentCart:
            return .get
        case .createNewCart:
            return .post
        case .addProdsToCart:
            return .post
        case .editProdInCart:
            return .put
        case .deleteProdInCart:
            return .delete
        case .getImportHistory:
            return .get
        case .getImportHistoryItem:
            return .get
        case .makeImportHistory:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .checkCurrentCart:
            return .requestPlain
        case .getCurrentCart:
            return .requestPlain
        case .createNewCart:
            return .requestPlain
        case .addProdsToCart(let addingProd):
            return .requestJSONEncodable(addingProd)
        case .editProdInCart(let edititngProd):
            return .requestJSONEncodable(edititngProd)
        case .deleteProdInCart(let deletingProd):
            return .requestJSONEncodable(deletingProd)
        case .getImportHistory:
            return .requestPlain
        case .getImportHistoryItem:
            return .requestPlain
        case .makeImportHistory(let importCart):
            return .requestJSONEncodable(importCart)
        }
    }
    
    
}
