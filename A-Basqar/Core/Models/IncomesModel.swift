//
//  IncomesModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 19.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

//Getting
struct Income: Codable {
    var id: Int?
    var exportObject: ExportCartObject?
    var name: String?
    var status: String?
    var fact_cash: String?
    var cash_sum: String?
    var comment: String?
    var date: String?
    var contragent: Contragent?
    var account: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "income_id"
        case exportObject =  "export_object"
        case name = "income_name"
        case status = "income_status"
        case fact_cash
        case cash_sum
        case comment
        case date
        case contragent
        case account
    }
}

//Sending
struct IncomeByExport: Codable {
    var exportObject: Int?
    var cash: String?
    var comment: String?
    
    enum CodingKeys: String, CodingKey {
        case exportObject =  "export_object"
        case cash = "fact_cash"
        case comment
    }
}

//Sending
struct IncomeByContr: Codable {
    var contragent: Int?
    var cash: String?
    var comment: String?
    
    enum CodingKeys: String, CodingKey {
        case contragent
        case cash = "fact_cash"
        case comment
    }
}
