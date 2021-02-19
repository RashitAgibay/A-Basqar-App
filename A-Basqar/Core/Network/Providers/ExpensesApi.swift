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
    case createCheckByImport(expenseByImport: ExpenseByImport)
    case cretaCheckByContr(expenseByContr: ExpenseByContr)
}

extension ExpencesApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getExpensesHistory:
            return EndPoint.Expenses.getExpensesHistory
        case .createCheckByImport:
            return EndPoint.Expenses.createExpenseByImport
        case .cretaCheckByContr:
            return EndPoint.Expenses.createExpenseByContr
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExpensesHistory:
            return .get
        case .createCheckByImport:
            return .post
        case .cretaCheckByContr:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getExpensesHistory:
            return .requestPlain
        case .createCheckByImport(let expenseByImport):
            return .requestJSONEncodable(expenseByImport)
        case .cretaCheckByContr(let expenseByContr):
            return .requestJSONEncodable(expenseByContr)
        }
    }
}
