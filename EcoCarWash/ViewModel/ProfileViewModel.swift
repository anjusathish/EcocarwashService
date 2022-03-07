//
//  ProfileViewModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 26/12/21.
//

import Foundation

protocol ProfileDelegate {
    func managerProfileInfo(_info: ProfileData)
    func successful(message : String)
    func failure(message : String)
}

struct UpdateProfileRequest: Codable {
    let name: String
    let mobile_no: String
    let profile_image: String
}

struct UpdateBankRequest: Codable {
    let account_holder_name: String
    let account_number: String
    let ifsc_code: String
    let bank_name: String
    let mobile_number: String
}

struct ChangePasswordRequest: Codable {
    let old_password: String
    let new_password: String
}

class ProfileViewModel {
    
    var delegate: ProfileDelegate!
    
    func getProfile(userId: String) {
        
        ProfileServiceHelper.request(router: ProfileServiceManager.getProfileInfo(userId: userId), completion: { (result : Result<ProfileModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    if let data = data.data {
                        self.delegate.managerProfileInfo(_info: data)
                    }
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
    
    func getBankDetails() {
        
        ProfileServiceHelper.request(router: ProfileServiceManager.getBankDetails, completion: { (result : Result<ProfileModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    if let data = data.data {
                        self.delegate.managerProfileInfo(_info: data)
                    }
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
    
    func updateProfile(userId: String, request: UpdateProfileRequest) {
        
        ProfileServiceHelper.request(router: ProfileServiceManager.updateProfile(userId: userId, _info: request), completion: { (result : Result<ProfileModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(_) : self.delegate.successful(message: "Updated Successfully!")
                    
                case .failure(let error): self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func changePassword(userId: String, request: ChangePasswordRequest) {
        
        ProfileServiceHelper.request(router: ProfileServiceManager.changePassword(userId: userId, _info: request), completion: { (result : Result<ProfileModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(_) :
                    
                    self.delegate.successful(message: "Password Changed Successfully, Please Login again!")
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func updateBankDetails(request: UpdateBankRequest, id: String) {
        
        ProfileServiceHelper.request(router: ProfileServiceManager.updateBank(_info: request, id: id), completion: { (result : Result<ProfileModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(_) : self.delegate.successful(message: "Updated Successfully!")
                    
                case .failure(let error): self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
}
