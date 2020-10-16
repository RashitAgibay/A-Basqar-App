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
    @objc dynamic var totalMoney = Int()
    @objc dynamic var historyID = Int()
    
    
//    func encode(with coder: NSCoder) {
//
//        coder.encode(importNubmer, forKey: "importNubmer")
//        coder.encode(billNumber, forKey: "billNumber")
//        coder.encode(date, forKey: "date")
//        coder.encode(contragent, forKey: "contragent")
//        coder.encode(totalMoney, forKey: "totalMoney")
//    }
//
//    required  init?(coder: NSCoder) {
//
//        let importNubmer = coder.decodeObject(forKey: "importNubmer") as! String
//        let billNumber = coder.decodeObject(forKey: "billNumber") as! String
//        let date = coder.decodeObject(forKey: "date") as! String
//        let contragent = coder.decodeObject(forKey: "contragent") as! String
//        let totalMoney = coder.decodeInteger(forKey: "totalMoney")
//
//    }
}
