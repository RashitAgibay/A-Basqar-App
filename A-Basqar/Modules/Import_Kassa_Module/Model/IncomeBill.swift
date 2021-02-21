//
//  IncomeBill.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import Foundation
import RealmSwift

class IncomeBill: Object  {
    
    @objc dynamic var importNubmer = String()
    @objc dynamic var billNumber = String()
    @objc dynamic var date = String()
    @objc dynamic var contragent = String()
    @objc dynamic var totalMoney = String()
    @objc dynamic var historyID = Int()
    
}
