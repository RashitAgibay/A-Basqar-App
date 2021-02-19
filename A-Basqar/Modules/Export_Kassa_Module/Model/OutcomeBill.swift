//
//  Bill.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import Foundation
import RealmSwift

class OutcomeBill: Object  {
    @objc dynamic var importNubmer = String()
    @objc dynamic var billNumber = String()
    @objc dynamic var date = String()
    @objc dynamic var contragent = String()
    @objc dynamic var totalMoney = String()
    @objc dynamic var importId = Int()
}
