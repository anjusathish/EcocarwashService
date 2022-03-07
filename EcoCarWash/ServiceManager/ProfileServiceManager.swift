//
//  ProfileServiceManager.swift
//  Eco carwash Service
//
//  Created by Indium Software on 26/12/21.
//

import Foundation

enum ProfileServiceManager {
    
    case getProfileInfo(userId: String)
    case getBankDetails
    case updateProfile(userId: String, _info: UpdateProfileRequest)
    case changePassword(userId: String, _info: ChangePasswordRequest)
    case updateBank(_info: UpdateBankRequest, id: String)

    var scheme: String {
        switch self {
        case .getProfileInfo, .updateProfile, .getBankDetails, .updateBank, .changePassword : return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .getProfileInfo, .updateProfile, .getBankDetails, .updateBank, .changePassword : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .getProfileInfo, .updateProfile, .getBankDetails, .updateBank, .changePassword : return API.port
        }
    }
    
    var path: String {
        switch self {
        case .getProfileInfo(let userId), .updateProfile(let userId, _): return API.path + "manage_profile/" + userId + "/"
        case .changePassword(let userId, _):  return API.path + "manage_profile/" + userId + "/"
        case .getBankDetails :  return API.path + "manage_bank_details/"
        case .updateBank(_, let id):  return API.path + "manage_bank_details/" + id + "/"
        }
    }
    
    var method: String {
        switch self {
        case .getProfileInfo, .getBankDetails : return "GET"
        case .updateProfile, .updateBank, .changePassword : return "PATCH"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getProfileInfo, .updateProfile, .getBankDetails, .updateBank, .changePassword: return nil
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .getProfileInfo, .updateProfile, .getBankDetails, .updateBank, .changePassword : return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .getProfileInfo, .getBankDetails : return nil
    
        case .updateProfile(_, let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
      
        case .updateBank(let request, _) :
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
            
        case .changePassword(_, let request) :
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        }
    }
    
    var formDataParameters : [String : Any]? {
        switch self {
        case .getProfileInfo, .updateProfile, .getBankDetails, .updateBank, .changePassword : return nil
        }
    }
}
