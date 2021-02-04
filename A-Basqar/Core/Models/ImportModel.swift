//
//  ImportModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 02.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

//Sending
struct AddingImportProd: Codable {
    var product_id: Int?
    var amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case product_id = "import_product"
        case amount = "prod_amount_in_cart"
    }
}

//Sending
struct EditingImportProd: Codable {
    var product_id: Int?
    var amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case product_id  = "im_prod_id"
        case amount = "prod_amount_in_cart"
    }
}

//Sending
struct DeletingImportProd: Codable {
    var product_id: Int?
    
    enum CodingKeys: String, CodingKey {
        case product_id = "im_prod_id"
    }
}

//Sending
struct ImportCartModel: Codable {
    var contragent_id: Int?
    var cash: String?
    
    enum CodingKeys: String, CodingKey {
        case contragent_id = "import_contragent"
        case cash = "cash_sum" 
    }
}


//Getting
struct CommonImportApiResponse: Codable {
    var importObject: String?
    
    enum CodingKeys: String, CodingKey {
        case importObject = "import_object"
    }
}

//Getting
struct ImportProduct: Codable {
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
struct ImportCartProduct: Codable {
    var productId: Int?
    var importProduct: ImportProduct?
    var amount: Int?
    var date: String?
    var accountId: Int?
    var importObjectId: Int?
    
    enum CodingKeys: String, CodingKey {
        case productId = "im_prod_id"
        case importProduct = "import_product"
        case amount = "prod_amount_in_cart"
        case date = "date"
        case accountId = "account"
        case importObjectId = "im_shopping_car_obj"
    }
}

//Getting
struct ImportCartObject: Codable {
    var id: Int?
    var contragent: Contragent?
    var status: String?
    var date: String?
    var cashSum: String?
    var accountID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "im_shopping_cart_id"
        case contragent = "import_contragent"
        case status = "status"
        case date = "date"
        case cashSum = "cash_sum"
        case accountID = "account"
    }
}

//Getting
struct ImportCart: Codable {
    var cartObject: ImportCartObject?
    var cartProduct: [ImportCartProduct]?
    
    enum CodingKeys: String, CodingKey {
        case cartObject = "shopping_cart_obj"
        case cartProduct = "import_products"
    }
}

