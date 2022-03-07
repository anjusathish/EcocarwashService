//
//  AppointmentViewModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 06/01/22.
//

import Foundation

protocol AppointmentDelegate {
    func getAppointmentList(_data: [AppointmentData])
    func getAppointmentData(_data: AppointmentData)
    func getServiceListInfo(_data: [ServiceData], message: String)
    func getStoreTimingData(_data: TimeData)
    func successful(message: String)
    func failure(message : String)
}

struct UpdateAppointmentRequest: Codable {
    let cleaner: String
    let appointment_status: String
    let tracking_id: String
}

struct ServiceRequest: Codable {
    let service_map_ids: [Int]
}

struct TimingRequest: Codable {
    let start_time : String
    let end_time   : String
}

struct UploadImageRequest: Codable {
    let image       : String
    let appointment : Int
    let image_type  : String
}

class AppointmentViewModel {
    
    var delegate: AppointmentDelegate!
    
    func getAppointmentList() {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.listAppointment, completion: { (result : Result<AppointmentModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    self.delegate.getAppointmentList(_data: data.data ?? [])
                    AppointmentManager.shared.appointment = data.data
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func getAppointmentList(status: AppointmentStatus) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getAppointmentList(status: status), completion: { (result : Result<AppointmentModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    self.delegate.getAppointmentList(_data: data.data ?? [])
                    AppointmentManager.shared.appointment = data.data
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func getAppointmentListBy(status: AppointmentStatus, date: String) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getAppointmentBy(status: status, date: date), completion: { (result : Result<AppointmentModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    self.delegate.getAppointmentList(_data: data.data ?? [])
                    AppointmentManager.shared.appointment = data.data
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func getAppointment(id: String) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getAppointment(id: id), completion: { (result : Result<AppointmentDetailModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    if let data = data.data {
                        self.delegate.getAppointmentData(_data: data)
                    }
                    
                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func getServiceList() {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getServiceList, completion: { (result : Result<ServiceModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) : self.delegate.getServiceListInfo(_data: data.data ?? [], message: "")

                case .failure(let error): self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func updateServiceList(info: ServiceRequest) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.updateService(info: info), completion: { (result : Result<ServiceModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    self.delegate.getServiceListInfo(_data: data.data ?? [], message: data.message ?? "")

                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func getStoreTiming() {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getStoreTiming, completion: { (result : Result<StoreTimingModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) :
                    
                    if let data = data.data {
                        self.delegate.getStoreTimingData(_data: data)
                    }

                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func updateStoreTiming(id: String, info: TimingRequest) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.updateStoreTiming(id: id, info: info), completion: { (result : Result<StoreTimingModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) : self.delegate.successful(message: data.message ?? "")

                case .failure(let error): self.delegate.failure(message: "\(error)")

                }
            }
        })
    }

    func updateAppointment(id: String, info: UpdateAppointmentRequest) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.updateAppointment(id: id, request: info), completion: { (result : Result<UpdateAppointmentModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) : self.delegate.successful(message: data.message ?? "")

                case .failure(let error): self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func updateAppointmentImage(info: UploadImageRequest) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.manageAppointmentImage(request: info), completion: { (result : Result<AppointmentImageModel, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data) : self.delegate.successful(message: data.message ?? "")

                case .failure(let error): self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
}
