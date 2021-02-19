//
//  ExpensesNetworkManager.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 17.02.2021.
//  Copyright © 2021 Ilyas Shomat. All rights reserved.
//

import Foundation
import Moya

protocol ExpensesNetworkable {
    var provider: MoyaProvider<ExpencesApi> { get }
    
    func getExpensesHistory(completion: @escaping ([Expense]?, Error?) -> ())
    func createExpenseByImport(expenseByImport: ExpenseByImport, comletion: @escaping (CommonApiResponse?, Error?) -> ())
    func createExpenseByContr(expenseByContr: ExpenseByContr, completion: @escaping (CommonApiResponse?, Error?) -> ())
}

class ExpensesNetworkManager: ExpensesNetworkable {
    public static let service = ExpensesNetworkManager()
    var provider = MoyaProvider<ExpencesApi>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getExpensesHistory(completion: @escaping ([Expense]?, Error?) -> ()) {
        provider.request(.getExpensesHistory) { (result) in
            switch result {
            case .success(let response):
                do {
                    let history = try JSONDecoder().decode([Expense].self, from: response.data)
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
    
    func createExpenseByImport(expenseByImport: ExpenseByImport, comletion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.createCheckByImport(expenseByImport: expenseByImport)) { (result) in
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
    
    func createExpenseByContr(expenseByContr: ExpenseByContr, completion: @escaping (CommonApiResponse?, Error?) -> ()) {
        provider.request(.cretaCheckByContr(expenseByContr: expenseByContr)) { (result) in
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
