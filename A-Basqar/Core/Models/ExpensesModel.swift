//
//  ExpensesModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 17.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

//Getting
struct Expense: Codable {
    var id: Int?
    var importObject: ImportCartObject?
    var name: String?
    var status: String?
    var fact_cash: String?
    var cash_sum: String?
    var comment: String?
    var date: String?
    var contragent: Int?
    var account: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "expense_id"
        case importObject =  "import_object"
        case name = "expense_name"
        case status = "expense_status"
        case fact_cash
        case cash_sum
        case comment
        case date
        case contragent
        case account
    }
}

