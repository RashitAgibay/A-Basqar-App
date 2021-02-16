//
//  ExportApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 15.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum ExportApi {
    case checkCurrentCart
    case getCurrentCart
    case createNewCart
    case addProdsToCart(addingProd: AddingExportProd)
    case editProdInCart(edititngProd: EditingExportProd)
    case deleteProdInCart(deletingProd: DeletingExportProd)
    case getExportHistory
    case getExportHistoryItem(historyItem: Int)
    case makeExportHistory(exportCart: ExportCartModel)
}

extension ExportApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .checkCurrentCart:
            return EndPoint.Export.checkCart
        case .getCurrentCart:
            return EndPoint.Export.getCart
        case .createNewCart:
            return EndPoint.Export.createNewCart
        case .addProdsToCart:
            return EndPoint.Export.addProdToCart
        case .editProdInCart:
            return EndPoint.Export.editCartProd
        case .deleteProdInCart:
            return EndPoint.Export.deleteCartProd
        case .getExportHistory:
            return EndPoint.Export.history
        case .getExportHistoryItem(let historyItem):
            return EndPoint.Export.historyItem + "\(historyItem)"
        case .makeExportHistory:
            return EndPoint.Export.makeHistory
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
        case .getExportHistory:
            return .get
        case .getExportHistoryItem:
            return .get
        case .makeExportHistory:
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
        case .getExportHistory:
            return .requestPlain
        case .getExportHistoryItem:
            return .requestPlain
        case .makeExportHistory(let exportCart):
            return .requestJSONEncodable(exportCart)
        }
    }
}
