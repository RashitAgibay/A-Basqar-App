//
//  ExportModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 15.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

//Sending
struct AddingExportProd: Codable {
    var product_id: Int?
    var amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case product_id = "export_product"
        case amount = "prod_amount_in_cart"
    }
}

//Sending
struct EditingExportProd: Codable {
    var product_id: Int?
    var amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case product_id  = "ex_prod_id"
        case amount = "prod_amount_in_cart"
    }
}

//Sending
struct DeletingExportProd: Codable {
    var product_id: Int?
    
    enum CodingKeys: String, CodingKey {
        case product_id = "ex_prod_id"
    }
}

//Sending
struct ExportCartModel: Codable {
    var contragent_id: Int?
    var cash: String?
    
    enum CodingKeys: String, CodingKey {
        case contragent_id = "export_contragent"
        case cash = "cash_sum"
    }
}

//Getting
struct CommonExportApiResponse: Codable {
    var exportObject: String?
    var message: String?
    var desc: String?
    
    enum CodingKeys: String, CodingKey {
        case exportObject = "export_object"
        case message
        case desc
    }
}

//Getting
struct ExportProduct: Codable {
    var productId: Int?
    var product: Product?
    var amount: Int?
    var storeId: Int?
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case product = "company_product"
        case amount = "product_amount"
        case storeId = "store"
    }
}

//Getting
struct ExportCartProduct: Codable {
    var productId: Int?
    var exportProduct: ExportProduct?
    var amount: Int?
    var date: String?
    var accountId: Int?
    var exportObjectId: Int?
    
    enum CodingKeys: String, CodingKey {
        case productId = "ex_prod_id"
        case exportProduct = "export_product"
        case amount = "prod_amount_in_cart"
        case date = "date"
        case accountId = "account"
        case exportObjectId = "ex_shopping_car_obj"
    }
}

//Getting
struct ExportCartObject: Codable {
    var id: Int?
    var contragent: Contragent?
    var status: String?
    var date: String?
    var cashSum: String?
    var accountID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "ex_shopping_cart_id"
        case contragent = "export_contragent"
        case status = "status"
        case date = "date"
        case cashSum = "cash_sum"
        case accountID = "account"
    }
}

//Getting
struct ExportCart: Codable {
    var cartObject: ExportCartObject?
    var cartProduct: [ExportCartProduct]?
    
    enum CodingKeys: String, CodingKey {
        case cartObject = "shopping_cart_obj"
        case cartProduct = "export_products"
    }
}
