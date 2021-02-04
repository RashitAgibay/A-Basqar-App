//
//  ProfileModel.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 29.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

// Sending
struct EditingProfileModel: Codable {
    var fullname: String
    var username: String
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case fullname = "full_name"
        case username
        case status
    }
}

// Sending
struct EditingPasswordModel: Codable {
    var oldPassword: String
    var newPassword: String
    
    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
    }
}

// Getting
struct UserProfile: Codable {
    var id: Int
    var store: Store
    var fullname: String
    var username: String
    var status: String
    var active_account: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case store = "store"
        case fullname = "full_name"
        case username
        case status
        case active_account
    }
}
