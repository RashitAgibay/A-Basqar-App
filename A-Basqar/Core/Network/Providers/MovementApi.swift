//
//  MovementApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 24.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum MovementApi {
    case getCurrentCart
}

extension MovementApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getCurrentCart:
            return EndPoint.Movement.getCurrentCart
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrentCart:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getCurrentCart:
            return .requestPlain
        }
    }
}
