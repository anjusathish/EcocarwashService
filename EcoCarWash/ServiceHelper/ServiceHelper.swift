//
//  ServiceHelper.swift
//  Kinder Care
//
//  Created by CIPL0668 on 05/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit


enum StatusCode : Int {
    case success         = 200
    case create          = 201
    case badRequest      = 400
    case notFound        = 404
    case noContent       = 202
    case serverError     = 500
    case unAuthorized    = 401
    case tooManyAttempts = 429
    case tokenExpired    = 703
}


enum ContentType : String {
    case x_www_form_urlEncoded = "application/x-www-form-urlencoded"
    case json = "application/json"
    case contentType = "Content-Type"
}

class ServiceHelper : NSObject {
    
    static let instance = ServiceHelper()
    let window = UIApplication.shared.windows.first
    
    func requestFormData(withData data : Data, forRequest request : URLRequest, completion: @escaping (Data?, Error?, StatusCode) -> Void) {
        var _request = request
      
        if let token =  UserManager.shared.currentUser?.accessToken {
            _request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        loadDataSession(forData: data, withURLRequest: _request, completionHandler: {
            data, response, error in
            self.processResponse(urlRequest: request, data: data, response: response, error: error, completion: completion)
        })
    }
    
    func request(forUrlRequest urlRequest : URLRequest, completion: @escaping (Data?, Error?, StatusCode) -> Void) {
        var _urlRequest = urlRequest
      
        if let token =  UserManager.shared.currentUser?.accessToken {
            _urlRequest.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }

        loadURLSession(withURLRequest: _urlRequest, completionHandler: {
            data, response, error in
            self.processResponse(urlRequest: urlRequest, data: data, response: response, error: error, completion: completion)
        })
    }
    
    private func loadURLSession(withURLRequest request : URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            completionHandler(data,response,error)
        }
        
        dataTask.resume()
    }
    
    private func loadDataSession(forData data : Data, withURLRequest request : URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
            completionHandler(data,response,error)
        }).resume()
    }
    
    private func processResponse(urlRequest : URLRequest, data : Data?, response : URLResponse?, error : Error?, completion : @escaping (Data?, Error?, StatusCode) -> Void) {
        
        guard let httpResponse = response as? HTTPURLResponse, let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
            completion(data, error, .tooManyAttempts)
            return
        }
        completion(data,error,statusCode)
    }
}

extension Data {
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
