//
//  ProductModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 02.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

struct Product: Codable {
    var productId: Int?
    var productName: String?
    var productBarcode: String?
    var productImportPrice: Int?
    var productExportPrice: Int?
    var productCategory: Int?
    var productCompany: Int?
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productName = "product_name"
        case productBarcode = "product_barcode"
        case productImportPrice = "product_import_price"
        case productExportPrice = "product_export_price"
        case productCategory = "product_category"
        case productCompany = "product_company"
    }
}


struct StoreProduct: Codable {
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
        case store = "store"
        
    }
}

struct FirstLevelCat: Codable {
    var id: Int?
    var name: String?
    var level: Int?
    var index: String?
    var company: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "category_id"
        case name = "category_name"
        case level = "category_level"
        case index = "category_index_id"
        case company = "category_company"
    }
}

