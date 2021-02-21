//
//  ReportModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 21.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

//Sending
struct ReportDate: Codable {
    var startDate: String?
    var endDate: String?
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

//Getting
struct CashReport: Codable {
    var totalBalance: Int?
    var totalIncome: Int?
    var totalExpense: Int?
    var totalStartBalance: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalBalance = "total_balance"
        case totalIncome = "total_income"
        case totalExpense = "total_expense"
        case totalStartBalance = "total_start_balance"
    }
}

//Getting
struct ProductReport: Codable {
    var id: Int?
    var name: String?
    var startCount: String?
    var endCount: String?
    var importCount: String?
    var exportCount: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "prod_id"
        case name = "prod_name"
        case startCount = "count_on_start"
        case endCount = "count_on_end"
        case importCount = "import_count"
        case exportCount = "export_count"
    }
}

