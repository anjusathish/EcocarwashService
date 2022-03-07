//
//  CleanerViewModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 29/12/21.
//

import Foundation

protocol CleanerDelegate {
    func getCleanerList(_cleanerListInfo: [Cleaner])
    func successful(message: String)
    func failure(message : String)
}

struct CleanerRequest: Codable {
    let name: String
    let email: String
    let mobile_no: String
    let document: String
}

class CleanerViewModel {
    
    var delegate: CleanerDelegate!
    
    func getCleanerList() {
        
        CleanerServiceHelper.request(router: CleanerServiceManager.getCleanerList, completion: { (result : Result<CleanerModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    if let data = data.data {
                        self.delegate.getCleanerList(_cleanerListInfo: data.results ?? [])
                    }
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: error.localizedDescription)
                }
            }
        })
    }
    
    func availableCleanersOn(date: String) {
        
        CleanerServiceHelper.request(router: CleanerServiceManager.getAvailableCleanerOn(date: date), completion: { (result : Result<CleanerModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    if let data = data.data {
                        self.delegate.getCleanerList(_cleanerListInfo: data.results ?? [])
                    }
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: error.localizedDescription)
                }
            }
        })
    }
    func createCleaner(request: CleanerRequest) {
        
        CleanerServiceHelper.request(router: CleanerServiceManager.createCleaner(_info: request), completion: { (result : Result<CreateCleanerModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) : self.delegate.successful(message: data.message ?? "")
                    
                case .failure(let error): self.delegate.failure(message: error.localizedDescription)
                
                }
            }
        })
    }
}
