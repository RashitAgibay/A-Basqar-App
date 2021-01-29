//
//  ProfileApiService.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 29.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol ProfileNetworkable {
    var provider: MoyaProvider<ProfileApi> { get }
    
    func getProfileInfo(comletion: @escaping (UserProfile?, Error?) -> ())
    func editProfileData(comletion: @escaping (EditingProfileModel?, Error?) -> ())
    func editPassword(comletion: @escaping (EditingPasswordModel?, Error?) -> ())
}

class ProfileNetworManager: ProfileNetworkable {
    var provider = MoyaProvider<ProfileApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])

    func getProfileInfo(comletion: @escaping (UserProfile?, Error?) -> ()) {
        provider.request(.getProfileInfo) { (response) in
            switch response {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let userProfileData = try decoder.decode(UserProfile.self, from: value.data)
                    comletion(userProfileData, nil)
                }
                catch let error {
                    comletion(nil, error)
                }
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func editProfileData(comletion: @escaping (EditingProfileModel?, Error?) -> ()) {
        
    }
    
    func editPassword(comletion: @escaping (EditingPasswordModel?, Error?) -> ()) {
        
    }
}
