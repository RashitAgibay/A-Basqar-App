//
//  IncomesApiManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 19.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol IncomesNetworkable {
    var provider: MoyaProvider<IncomesApi> { get }
    
    func getIncomesHistory(completion: @escaping ([Income]?, Error?) -> ())
    func getIncomesHistoryItem(historyId: Int, completion: @escaping (Income?, Error?) -> ())
    func createIncomeByExport(incomeByExport: IncomeByExport, comletion: @escaping (CommonApiResponse?, Error?) -> ())
    func createIncomeByContr(incomeByContr: IncomeByContr, completion: @escaping (CommonApiResponse?, Error?) -> ())
}

class IncomesNetworkManager: IncomesNetworkable {
    public static let service = IncomesNetworkManager()
    var provider = MoyaProvider<IncomesApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getIncomesHistory(completion: @escaping ([Income]?, Error?) -> ()) {
        provider.request(.getIncomesHistory) { (result) in
            switch result {
            case .success(let response):
                do {
                    let history = try JSONDecoder().decode([Income].self, from: response.data)
                    completion(history, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getIncomesHistoryItem(historyId: Int, completion: @escaping (Income?, Error?) -> ()) {
        provider.request(.getIncomesHistoryItem(historyId: historyId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let history = try JSONDecoder().decode(Income.self, from: response.data)
                    completion(history, nil)
                }
                catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func createIncomeByExport(incomeByExport: IncomeByExport, comletion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.createCheckByExport(incomeByExport: incomeByExport)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonApiResponse.self, from: response.data)
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
    
    func createIncomeByContr(incomeByContr: IncomeByContr, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.createCheckByContr(incomeByContr: incomeByContr)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode(CommonApiResponse.self, from: response.data)
                    completion(message, nil)
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
