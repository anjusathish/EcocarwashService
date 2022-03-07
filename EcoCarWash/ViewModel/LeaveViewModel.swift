//
//  LeaveViewModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 26/12/21.
//

import Foundation

protocol LeaveDelegate {
    func getLeaveInfo(_leaveData: [Leave])
    func successful(message: String)
    func failure(message : String)
}

struct ApplyLeaveRequest: Codable {
    let title: String
    let description: String
    let from_date: String
    let to_date: String
}

struct UpdateLeaveRequest: Codable {
    let is_approved: Bool
}

class LeaveViewModel {
    
    var delegate: LeaveDelegate!
    
    func getProfile() {
        
        LeaveServiceHelper.request(router: LeaveServiceManager.getLeave, completion: { (result : Result<LeaveModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    if let data = data.data {
                        self.delegate.getLeaveInfo(_leaveData: data)
                    }
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
    
    func applyLeave(request: ApplyLeaveRequest) {
        
        LeaveServiceHelper.request(router: LeaveServiceManager.applyLeave(_info: request), completion: { (result : Result<ApplyLeaveModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) : self.delegate.successful(message: data.message ?? "")

                case .failure(let error): self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
    
    func updateLeave(id: String, request: UpdateLeaveRequest) {
        
        LeaveServiceHelper.request(router: LeaveServiceManager.updateLeave(_info: request, id: id), completion: { (result : Result<ApplyLeaveModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) : self.delegate.successful(message: data.message ?? "")

                case .failure(let error): self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
}
