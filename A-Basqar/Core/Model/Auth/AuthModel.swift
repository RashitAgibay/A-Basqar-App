//
//  AuthModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 26.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    var username: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}

struct Token: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
