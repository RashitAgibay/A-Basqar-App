//
//  IncomesApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 19.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum IncomesApi {
    case getIncomesHistory
    case getIncomesHistoryItem(historyId: Int)
    case createCheckByExport(incomeByExport: IncomeByExport)
    case createCheckByContr(incomeByContr: IncomeByContr)
}

extension IncomesApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getIncomesHistory:
            return EndPoint.Incomes.getIncomesHistory
        case .getIncomesHistoryItem(let historyId):
            return EndPoint.Incomes.getIncomeHistoryItem + "\(historyId)"
        case .createCheckByExport:
            return EndPoint.Incomes.createIncomeByExport
        case .createCheckByContr:
            return EndPoint.Incomes.createIncomeByContr
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getIncomesHistory:
            return .get
        case .getIncomesHistoryItem:
            return .get
        case .createCheckByContr:
            return .post
        case .createCheckByExport:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getIncomesHistory:
            return .requestPlain
        case .getIncomesHistoryItem:
            return .requestPlain
        case .createCheckByExport(let incomeByExport):
            return .requestJSONEncodable(incomeByExport)
        case .createCheckByContr(let incomeByContr):
            return .requestJSONEncodable(incomeByContr)
        }
    }    
}
