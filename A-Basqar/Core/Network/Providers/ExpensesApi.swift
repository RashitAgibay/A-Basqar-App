//
//  ExpensesApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 17.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum ExpencesApi {
    case getExpensesHistory
}

extension ExpencesApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getExpensesHistory:
            return EndPoint.Expenses.getExpensesHistory
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExpensesHistory:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getExpensesHistory:
            return .requestPlain
        }
    }
}
