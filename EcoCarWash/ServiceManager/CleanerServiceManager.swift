//
//  CleanerServiceManager.swift
//  Eco carwash Service
//
//  Created by Indium Software on 29/12/21.
//

import Foundation

enum CleanerServiceManager {
    
    case getCleanerList
    case getAvailableCleanerOn(date: String)
    case createCleaner(_info: CleanerRequest)
    
    var scheme: String {
        switch self {
        case .getCleanerList, .createCleaner, .getAvailableCleanerOn : return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .getCleanerList, .createCleaner, .getAvailableCleanerOn : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .getCleanerList, .createCleaner, .getAvailableCleanerOn : return API.port
        }
    }
    
    var path: String {
        switch self {
        case .getCleanerList, .createCleaner, .getAvailableCleanerOn : return API.path + "manage_profile/"
        }
    }
    
    var method: String {
        switch self {
        case .getCleanerList, .getAvailableCleanerOn : return "GET"
        case .createCleaner : return "POST"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getCleanerList, .createCleaner : return nil
        case .getAvailableCleanerOn(let date): return [URLQueryItem(name: "availability", value: date)]
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .getCleanerList, .createCleaner, .getAvailableCleanerOn : return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .getCleanerList, .getAvailableCleanerOn : return nil
        case .createCleaner(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        }
    }
    
    var formDataParameters : [String : Any]? {
        switch self {
        case .getCleanerList, .createCleaner, .getAvailableCleanerOn : return nil
        }
    }
}
