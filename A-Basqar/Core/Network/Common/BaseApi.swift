//
//  BaseApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 29.01.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol BaseApiDelegate: TargetType {}

extension BaseApiDelegate {
    var baseURL: URL {
        #if DEBUG
        guard let url = URL(string: "http://127.0.0.1:8000") else {
            fatalError()
        }
        return url
        #else
        guard let url = URL(string: "") else {
            fatalError()
        }
        return url
        #endif
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        var token = ""
        if UserDefaults.standard.string(forKey: "new_userTokenKey") != nil {
            token = UserDefaults.standard.string(forKey: "new_userTokenKey") as! String
        }
        if token != nil {
            return [
                "Content-type": "application/json; charset=UTF-8",
                "Authorization": " Token \(token)"
            ]
        }
        else {
            return [
                "Content-type": "application/json; charset=UTF-8",
            ]
        }

    }
}
