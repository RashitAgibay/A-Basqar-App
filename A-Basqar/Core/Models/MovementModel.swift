//
//  MovementModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 23.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation


//Setting
struct AddingMovementProd: Codable {
    var product_id: Int?
    var amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case product_id = "movement_product"
        case amount = "product_amount"
    }
}

//Getting
struct CommomMovementResponse: Codable {
    var movementObject: String?
    var message: String?
    var desc: String?
    
    enum CodingKeys: String, CodingKey {
        case movementObject = "movement_object"
        case message
        case desc
    }
}

//Getting
struct MovementCart: Codable {
    var movementObject: MovementObject?
    var movementProds: [MovementCartProd]?
    
    enum CodingKeys: String, CodingKey {
        case movementObject = "movement_object"
        case movementProds = "movement_products"
    }
}

//Getting
struct MovementObject: Codable {
    var id: Int?
    var store: Store?
    var status: String?
    var date: String?
    var account: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "movement_id"
        case store = "store"
        case status = "status"
        case date = "date"
        case account = "account"
    }
}

//Getting
struct MovementCartProd: Codable {
    var id: Int?
    var product: MovementProd?
    var amount: Int?
    var date: String?
    var account: Int?
    var movementObject: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "movement_prod_id"
        case product = "movement_product"
        case amount = "product_amount"
        case date
        case account
        case movementObject = "movement_object"
    }
}

//Getting
struct MovementProd: Codable {
    var id: Int?
    var product: Product?
    var amount: Int?
    var category: Int?
    var store: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case product = "company_product"
        case amount = "product_amount"
        case category = "categor"
        case store
    }
}

