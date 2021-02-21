//
//  ReportApi.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 21.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

enum ReportApi {
    case getCashReport(dates: ReportDate)
    case getProductReport(dates: ReportDate)
}

extension ReportApi: BaseApiDelegate {
    var path: String {
        switch self {
        case .getCashReport:
            return EndPoint.Report.getCash
        case .getProductReport:
            return EndPoint.Report.getProcuts
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCashReport:
            return .post
        case .getProductReport:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCashReport(let dates):
            return .requestJSONEncodable(dates)
        case .getProductReport(let dates):
            return .requestJSONEncodable(dates)
        }
    }
}
