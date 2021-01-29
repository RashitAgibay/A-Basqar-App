//
//  EndPoint.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 27.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation

struct EndPoint {
    
    struct Auth {
        static let login = "/api/account/login"
    }
    
    struct Profile {
        static let getProfileInfo = "/api/account/profile"
        static let editProfileData = "/api/account/profile/update"
        static let editUserPassword = "/api/account/change_password"
    }
}
