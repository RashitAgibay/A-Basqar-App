//
//  EndPoint.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 27.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

struct EndPoint {
    struct Auth {
        static let login = "/api/account/login"
    }
    
    struct Profile {
        static let getProfileInfo = "/api/account/profile"
        static let editProfileData = "/api/account/profile/update"
        static let editUserPassword = "/api/account/change_password"
    }
    
    struct Import {
        static let checkCart = "/api/ex_im_prods/get_current_import_object"
        static let getCart = "/api/ex_im_prods/import_cart"
        static let createNewCart = "/api/ex_im_prods/create_new_import_cart_object"
        static let addProdToCart = "/api/ex_im_prods/add_prods_to_im_shop"
        static let editCartProd = "/api/ex_im_prods/edit_product_count_in_import_cart"
        static let deleteCartProd = "/api/ex_im_prods/delete_product_count_in_import_cart"
        static let history = "api/ex_im_prods/get_import_history"
        static let historyItem = "/api/ex_im_prods/get_import_history_item/"
        static let makeHistory = "/api/ex_im_prods/buy_new_products"
    }
    
    struct Export {
        static let checkCart = "/api/ex_im_prods/get_current_export_object"
        static let getCart = "/api/ex_im_prods/export_cart"
        static let createNewCart = "/api/ex_im_prods/create_new_export_cart_object"
        static let addProdToCart = "/api/ex_im_prods/add_prods_to_ex_shop"
        static let editCartProd = "/api/ex_im_prods/edit_product_count_in_export_cart"
        static let deleteCartProd = "/api/ex_im_prods/delete_product_count_in_export_cart"
        static let history = "api/ex_im_prods/get_export_history"
        static let historyItem = "/api/ex_im_prods/get_export_history_item/"
        static let makeHistory = "/api/ex_im_prods/sell_new_products"
    }
    
    struct Product {
        static let firstLevelCat = "/api/products/categories"
        static let exactCatprods = "/api/ex_im_prods/get_prods/"
        static let editPrices = "/api/products/edit_import_export_prices/"
    }
    
    struct Managment {
        static let contList = "/api/management/contragent"
        static let createContr = "/api/management/contragent/add"
        static let editContr = "/api/management/contragent/edit"
    }
    
    struct Expenses {
        static let getExpensesHistory = "/api/kassa/expense_kassa_history"
        static let getExpenseHistoryItem = "/api/kassa/expense_history/"
        static let createExpenseByImport = "/api/kassa/create_new_expense_export"
        static let createExpenseByContr = "/api/kassa/create_new_expense_contr"
    }
}
