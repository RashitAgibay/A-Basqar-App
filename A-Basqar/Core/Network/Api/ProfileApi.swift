//
//  ProfileApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 29.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum ProfileApi {
    case getProfileInfo
    case editProfileInfo(editingProfileData: EditingProfileModel)
    case editPassword(editingPasswordData: EditingPasswordModel)
}

extension ProfileApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getProfileInfo:
            return EndPoint.Profile.getProfileInfo
        case .editProfileInfo:
            return EndPoint.Profile.editProfileData
        case .editPassword:
            return EndPoint.Profile.editUserPassword
        }
    }

    var method: Moya.Method {
        switch self {
        case .getProfileInfo:
            return .get
        case .editProfileInfo:
            return .put
        case .editPassword:
            return .put
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getProfileInfo:
            return .requestPlain
        case .editProfileInfo(let editingProfileData):
            return .requestJSONEncodable(editingProfileData)
        case .editPassword(let editingPasswordData):
            return .requestJSONEncodable(editingPasswordData)
        }
    }
}
