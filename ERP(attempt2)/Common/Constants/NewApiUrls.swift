//
//  NewApiUrls.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/2/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import Foundation

let newMainUrl: String = "https://abasqar.pythonanywhere.com/"

//MARK: - Cat list url
let firstLevelCategoryListUrl: String = newMainUrl +  "shop/v1/api/add/category/"

let productListUrl: String = newMainUrl + "shop/v1/api/goods/list/"

//MARK: - Import
let importShoppingCartURL: String = newMainUrl + "import/v1/api/import-shopping-cart/"

let importContragentsListURL: String = newMainUrl + "shop/v1/api/buy-company/"

let importHistoryListURL: String = newMainUrl + "import/v1/api/import-history/"

let importCheckURL: String = newMainUrl + "import/v1/api/import-check/"

let importNullCheckURL: String = newMainUrl + "import/v1/api/import-null-check/"


//MARK: - Export

let exportShoppingCartURL: String = newMainUrl + "export/v1/api/export-shopping-cart/"

let exportContragentListURL: String = newMainUrl + "shop/v1/api/buy-company/"

let exportHistoryListURL: String = newMainUrl + "export/v1/api/export-history/"

let exportCheckURL: String = newMainUrl + "export/v1/api/export-check/"

let exportNullCheckURL: String  = newMainUrl + "export/v1/api/export-null-check/"
