//
//  ManagementModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 29.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

// Getting
struct Store: Codable {
    var id: Int
    var company: Company
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "store_id"
        case company = "company"
        case name = "store_name"
    }
}

// Getting
struct Company: Codable {
    var id: Int
    var name: String
    var bin: String
    
    enum CodingKeys: String, CodingKey {
        case id = "company_id"
        case name = "company_name"
        case bin = "company_bin"
    }
}

// Getting
struct Contragent: Codable {
    var id: Int?
    var name: String?
    var bin: String?
    var phoneNumber: String?
    var companyID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "contragent_id"
        case name = "name"
        case bin = "bin"
        case phoneNumber = "phone_number"
        case companyID = "company"
    }
}

// Sending
struct ContrSending: Codable {
    var name: String?
    var bin: String?
    var phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case bin = "bin"
        case phoneNumber = "phone_number"
    }
}
