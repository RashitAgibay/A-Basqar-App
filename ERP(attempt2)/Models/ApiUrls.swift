//
//  ApiUrls.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/17/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import Foundation



let mainUrl: String = "http://94.103.91.178/"

let loginUrl: String = mainUrl + "user-login"

let categoryUrl: String = mainUrl + "add/category/"

let goodListUrl: String = mainUrl + "goods/list/"

//MARK: - Продажа корзинасы
let basketUrl: String = mainUrl + "company-shoping-card/"

let sellingHistoryUrl: String = mainUrl + "company-buy-history/"

let sellingKassaUrl: String = mainUrl + "company-buy-checks/"

//MARK: - Покупатели/Поставщики
let buyerCompaniesUrl: String = mainUrl + "buy-company/"

//MARK: - Закуп корзинасы
let buyingBasketURL: String = mainUrl + "grow-company-shoping-card/"

let buyingHistoryUrl: String = mainUrl + "grow-company-buy-history/"

let buyingChecsUrl: String = mainUrl + "grow-company-buy-checks/"


// MARK: - Ақша мен тауар отчеттары:
let goodReportUrl: String = mainUrl + "goods-billing/"

let moneyReportUrl: String = mainUrl + "money-billing/"


let nullIncomeKassaUrl: String = mainUrl + "export-null-checks/"

let nullOutcomeKassaUrl: String = mainUrl + "import-null-checks/"


