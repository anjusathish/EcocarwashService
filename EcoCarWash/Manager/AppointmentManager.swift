//
//  AppointmentManager.swift
//  Eco carwash Service
//
//  Created by Indium Software on 11/01/22.
//

import Foundation

class AppointmentManager: NSObject  {
    
    private var _appointment: [AppointmentData]?

    var appointment : [AppointmentData]? {
        get
        {
            return _appointment
        }
        set
        {
            _appointment = newValue
            
            if let _ = _appointment {
                saveService()
            }
        }
    }

    class var shared: AppointmentManager {
        struct Singleton {
            static let instance = AppointmentManager()
        }
        return Singleton.instance
    }
    
    private struct SerializationKeys {
        static let appointment = "appointment"
    }
    
    private override init () {
        super.init()
        
        if UserManager.shared.isLoggedInUser() {
            getService()
        }
    }

    // MARK: - Service data get and save
    func getService() {
        let defaults = UserDefaults.standard
        if let savedService = defaults.object(forKey: SerializationKeys.appointment) as? Data {
            let decoder = JSONDecoder()
            if let loadData = try? decoder.decode([AppointmentData].self, from: savedService) {
                appointment = loadData
            }
        }
    }

    func saveService() {
        if let user = _appointment {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.appointment)
            }
        }
    }

    func removeService() {
        UserDefaults.removeObjectForKey(SerializationKeys.appointment)
        appointment = nil
    }
    
}
