//
//  AuthModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 26.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

// Sending
struct UserInfo: Codable {
    var username: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}

struct Token: Codable {
    var token: String?
    var not_exist: Array<String>?
    
    enum CodingKeys: String, CodingKey {
        case token
        case not_exist = "non_field_errors"
    }
}
