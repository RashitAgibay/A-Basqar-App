//
//  CommonApiResponse.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 01.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

// Getting
struct CommonApiResponse: Codable {
    var status: String?
    var desc: String?
    var response: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case desc
        case response
    }
}

