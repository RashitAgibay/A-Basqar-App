//
//  ReportNetworkManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 21.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol ReportNetworkable {
    var provider: MoyaProvider<ReportApi> { get }
    
    func getCashReport(dates: ReportDate, completion: @escaping (CashReport?, Error?) -> ())
    func getProductsReport(dates: ReportDate, completion: @escaping ([ProductReport]?, Error?) -> ())
}

class ReportNetworkManager: ReportNetworkable {
    public static let service = ReportNetworkManager()
    var provider = MoyaProvider<ReportApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getCashReport(dates: ReportDate, completion: @escaping (CashReport?, Error?) -> ()) {
        provider.request(.getCashReport(dates: dates)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let report = try JSONDecoder().decode(CashReport.self, from: response.data)
                    completion(report, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getProductsReport(dates: ReportDate, completion: @escaping ([ProductReport]?, Error?) -> ()) {
        provider.request(.getProductReport(dates: dates)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let report = try JSONDecoder().decode([ProductReport].self, from: response.data)
                    completion(report, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
