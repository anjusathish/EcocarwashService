//
//  AppointmentServiceManager.swift
//  Eco carwash Service
//
//  Created by Indium Software on 06/01/22.
//

import Foundation

enum AppointmentServiceManager {
    
    case listAppointment
    case getAppointmentList(status: AppointmentStatus)
    case getAppointmentBy(status: AppointmentStatus, date: String)
    case getAppointment(id: String)
    case getServiceList
    case updateService(info: ServiceRequest)
    case getStoreTiming
    case updateStoreTiming(id: String, info: TimingRequest)
    case updateAppointment(id: String, request: UpdateAppointmentRequest)
    case manageAppointmentImage(request: UploadImageRequest)

    var scheme: String {
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy, .getAppointment, .getServiceList, .updateService, .getStoreTiming, .updateStoreTiming, .updateAppointment, .manageAppointmentImage : return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy, .getAppointment, .getServiceList, .updateService, .getStoreTiming, .updateStoreTiming, .updateAppointment, .manageAppointmentImage : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy, .getAppointment, .getServiceList, .updateService, .getStoreTiming, .updateStoreTiming, .updateAppointment, .manageAppointmentImage : return API.port
        }
    }
    
    var path: String {
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy : return API.path + "manage_appointments/"
        case .getServiceList  : return API.path + "manage_services/"
        case .updateService   : return API.path + "manage_services/updater/"
        case .getStoreTiming  : return API.path + "manage_store_timings/"
        case .getAppointment(let id), .updateAppointment(let id, _) :  return API.path + "manage_appointments/" + id + "/"
        case .updateStoreTiming(let id, _): return API.path + "manage_store_timings/" + id + "/"
        case .manageAppointmentImage: return API.path + "manage_appointment_images/"
        }
    }
    
    var method: String {
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy, .getAppointment, .getServiceList, .getStoreTiming : return "GET"
        case .updateService, .updateStoreTiming, .updateAppointment : return "PATCH"
        case .manageAppointmentImage: return "POST"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .listAppointment, .getAppointment, .getServiceList, .updateService, .getStoreTiming, .updateStoreTiming, .updateAppointment, .manageAppointmentImage : return nil
        case .getAppointmentList(let status)  : return [URLQueryItem(name: "status", value: status.rawValue)]
        case .getAppointmentBy(let status, let date)  : return [URLQueryItem(name: "status", value: status.rawValue),
                                                                URLQueryItem(name: "date", value: date)]
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy, .getAppointment, .getServiceList, .updateService, .getStoreTiming, .updateStoreTiming, .updateAppointment, .manageAppointmentImage : return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy, .getAppointment, .getServiceList, .getStoreTiming : return nil
        case .updateService(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .updateStoreTiming(_, let request) :
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .updateAppointment(_, let request) :
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .manageAppointmentImage(let request) :
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        }
    }
    
    var formDataParameters : [String : Any]? {
        switch self {
        case .listAppointment, .getAppointmentList, .getAppointmentBy, .getAppointment, .getServiceList, .updateService, .getStoreTiming, .updateStoreTiming, .updateAppointment, .manageAppointmentImage : return nil
        }
    }
}
