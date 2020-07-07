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

//MARL: - Import shopping cart
let importShoppingCartURL: String = newMainUrl + "import/v1/api/import-shopping-cart/"

let importContragentsListURL: String = newMainUrl + "shop/v1/api/buy-company/"

let importHistoryListURL: String = newMainUrl + "import/v1/api/import-history/"

let importCheckURL: String = newMainUrl + "import/v1/api/import-check/"
