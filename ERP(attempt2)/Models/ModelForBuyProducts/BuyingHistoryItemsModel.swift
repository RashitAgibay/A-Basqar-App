//
//  BuyingHistoryItemsModel.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/3/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import Foundation

public var historyBuyingItemProducts: [String] = ["Картошка","Рис","Хлеб", "Картошка","Рис","Хлеб","Картошка","Рис","Хлеб"]

public var historyBuyingItemImages: [String] = ["img1","img2", "img3","img1","img2", "img3","img1","img2", "img3"]

public var historyBuyingItemPrices: [Int] = [180,180,180,180,180,180,180,180,180]

public var historyBuyingItemAmounts: [Int] = [28,28,28,28,28,28,28,28,28]

public var historyBuyingItemTotalPrices: [Int] = [5040,5040,5040,5040,5040,5040,5040,5040,5040]


struct GoodsInBasketStruct: Decodable {
    let export_price: Int!
}
