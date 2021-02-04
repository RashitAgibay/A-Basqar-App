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


