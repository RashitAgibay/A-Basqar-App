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
    case createNewContr(contr: ContrSending)
    case editContrData(contr: ContrSending)
    case getUserStores
    case getCompanyUsers
    case getExactStoreUser(storeId: Int)
    case createNewStore(storeName: Store)
    case editStore(storeId: Int, storeName: Store)
}

extension ManagementApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getContrList:
            return EndPoint.Managment.contList
        case .createNewContr:
            return EndPoint.Managment.createContr
        case .editContrData:
            return EndPoint.Managment.editContr
        case .getUserStores:
            return EndPoint.Managment.userStores
        case .getCompanyUsers:
            return EndPoint.Managment.getCompanyAllUsers
        case .getExactStoreUser(let storeId):
            return EndPoint.Managment.storeUsers + "\(storeId)"
        case .createNewStore:
            return EndPoint.Managment.newStore
        case .editStore(let storeId, _):
            return EndPoint.Managment.editStore + "\(storeId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getContrList:
            return .get
        case .createNewContr:
            return .post
        case .editContrData:
            return .put
        case .getUserStores:
            return .get
        case .getCompanyUsers:
            return .get
        case .getExactStoreUser:
            return .get
        case .createNewStore:
            return .post
        case .editStore:
            return .put

        }
    }
    
    var task: Task {
        switch self {
        case .getContrList:
            return .requestPlain
        case .createNewContr(let contr):
            return .requestJSONEncodable(contr)
        case .editContrData(let contr):
            return .requestJSONEncodable(contr)
        case .getUserStores:
            return .requestPlain
        case .getCompanyUsers:
            return .requestPlain
        case .getExactStoreUser:
            return .requestPlain
        case .createNewStore(let storeName):
            return .requestJSONEncodable(storeName)
        case .editStore(_, let storeName):
            return .requestJSONEncodable(storeName)
        }
    }    
}
