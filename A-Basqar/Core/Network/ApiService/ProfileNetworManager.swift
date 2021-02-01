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
    func editProfileData(editingProfileModel: EditingProfileModel, comletion: @escaping (CommonApiResponse?, Error?) -> ())
    func editPassword(editingPasswordModel: EditingPasswordModel, comletion: @escaping (CommonApiResponse?, Error?) -> ())
}

class ProfileNetworManager: ProfileNetworkable {
    public static let service = ProfileNetworManager()
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
    
    func editProfileData(editingProfileModel: EditingProfileModel, comletion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.editProfileInfo(editingProfileData: editingProfileModel)) { (response) in
            switch response {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let message = try decoder.decode(CommonApiResponse.self, from: value.data)
                    comletion(message, nil)
                }
                catch let error {
                    comletion(nil, error)
                }
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func editPassword(editingPasswordModel: EditingPasswordModel, comletion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.editPassword(editingPasswordData: editingPasswordModel)) { (response) in
            switch response {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let message = try decoder.decode(CommonApiResponse.self, from: value.data)
                    comletion(message, nil)
                }
                catch let error {
                    comletion(nil, error)
                }
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
}
