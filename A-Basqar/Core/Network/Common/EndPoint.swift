//
//  EndPoint.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 27.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

class EndPoint {
    public static let shared = EndPoint()
}

extension EndPoint {
    //Auth
    func getLoginEndPoint() -> String {
        return "/api/account/login"
    }
}
