//
//  LeaveServiceManager.swift
//  Eco carwash Service
//
//  Created by Indium Software on 26/12/21.
//

import Foundation

enum LeaveServiceManager {
    
    case getLeave
    case applyLeave(_info: ApplyLeaveRequest)
    case updateLeave(_info: UpdateLeaveRequest, id: String)
    
    var scheme: String {
        switch self {
        case .getLeave, .applyLeave, .updateLeave : return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .getLeave, .applyLeave, .updateLeave : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .getLeave, .applyLeave, .updateLeave : return API.port
        }
    }
    
    var path: String {
        switch self {
        case .getLeave, .applyLeave :  return API.path + "manage_leave/"
        case .updateLeave(_, let id) :  return API.path + "manage_leave/" + id + "/"
        }
    }
    
    var method: String {
        switch self {
        case .getLeave : return "GET"
        case .applyLeave : return "POST"
        case .updateLeave : return "PATCH"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getLeave, .applyLeave, .updateLeave : return nil
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .getLeave, .applyLeave, .updateLeave : return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .getLeave : return nil
        case .applyLeave(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .updateLeave(let request, _):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        }
    }
    
    var formDataParameters : [String : Any]? {
        switch self {
        case .getLeave, .applyLeave, .updateLeave : return nil
        }
    }
}
