//
//  LoginServiceHelper.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 02/11/21.
//

import Foundation

enum CustomError : Error {
    case message(String)
    case unKnown(String)
    case noContent
    case offline(String)
    case noDataFound
    case tooManyAttemps
}

class LoginServiceHelper {
    
    class func requestFormData<T: Codable>(router: SignupServiceManager, completion: @escaping (Result<T, CustomError>) -> ()) {
        
        let window = UIApplication.shared.windows.first
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.offline("Please Check Your Internet Connection")))
            return
        }
        
        MBProgressHUD.showAdded(to: window!, animated: true)
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.port = router.port
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method
        request.httpShouldHandleCookies = false

        for (key, value) in router.headerFields {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        if let parameters = router.formDataParameters {
            
            for(key, value) in parameters {
                print(key, value)
                if let image = value as? UIImage, let imageData = image.jpegData(compressionQuality: 1.0) {
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\("Image")\"\r\n".data(using: .utf8)!)
                    data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    data.append(imageData)
                }
                else {
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    data.append("\(value)".data(using: .utf8)!)
                }
            }
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        ServiceHelper.instance.requestFormData(withData: data, forRequest: request, completion: { data, error, statusCode  in
            
            DispatchQueue.main.async {
                
                MBProgressHUD.hide(for: window!, animated: true)
                
                switch statusCode {
                case .create: break
                case .success:
                    
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            
                            let responseObject = try! JSONDecoder().decode(T.self, from: _data)
                            print(responseObject)
                            completion(.success(responseObject))
                            
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                case .noContent :
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let status = dict["Status"] as? Bool {
                                
                                if status == true {
                                    let responseObject = try! JSONDecoder().decode(T.self, from: _data)
                                    print(responseObject)
                                    completion(.success(responseObject))
                                } else {
                                    if let errorMessages = dict["Message"] as? String{
                                        completion(.failure(.message(errorMessages)))
                                    }
                                    else {
                                        completion(.failure(.unKnown("Please Give Valid Data")))
                                    }
                                }
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                case .notFound:
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let errorMessages = dict["errors"] as? NSDictionary, let key = errorMessages.allKeys.first as? String, let value = errorMessages[key] as? String {
                                completion(.failure(.message(value)))
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                    
                case .serverError:
                    completion(.failure(.unKnown("Please Give Valid Data")))
                    
                    
                case .unAuthorized:
                    
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            
                            print(dict)
                            
                            if let errorMessages = dict["errors"] as? NSDictionary, let key = errorMessages.allKeys.first as? String, let value = errorMessages[key] as? String {
                                completion(.failure(.message(value)))
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                case .tooManyAttempts:
                    completion(.failure(.tooManyAttemps))
                    
                case .tokenExpired:
                    completion(.failure(.unKnown("Refresh token expired")))
                case .badRequest:
                    completion(.failure(.unKnown("Please Give Valid Data")))
                }
            }
        })
    }
    
    class func request<T: Codable>(router: SignupServiceManager, completion: @escaping (Result<T, CustomError>) -> ()) {
        
        let window = UIApplication.shared.windows.first
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.offline("Please Check Your Internet Connection")))
            return
        }
                
        MBProgressHUD.showAdded(to: window!, animated: true)

        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.port = router.port
        components.queryItems = router.parameters

        guard let url = components.url else { return }

        print(url)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: ContentType.contentType.rawValue)
        urlRequest.httpShouldHandleCookies = false
        
        for (key, value) in router.headerFields {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let data = router.body {
            urlRequest.httpBody = data
        }
        
        ServiceHelper.instance.request(forUrlRequest: urlRequest, completion: { data, error, statusCode  in
            
            DispatchQueue.main.async {
                
                MBProgressHUD.hide(for: window!, animated: true)
                
                switch statusCode {
                case .create:
                    
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            
                            print(dict)
                            
                            let responseObject = try! JSONDecoder().decode(T.self, from: _data)
                            print(responseObject)
                            completion(.success(responseObject))
                            
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }

                case .success:
                    
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            
                            print(dict)
                            
                            let responseObject = try! JSONDecoder().decode(T.self, from: _data)
                            print(responseObject)
                            completion(.success(responseObject))
                            
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                case .noContent :
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let status = dict["Status"] as? Bool {
                                
                                if status == true {
                                    let responseObject = try! JSONDecoder().decode(T.self, from: _data)
                                    print(responseObject)
                                    completion(.success(responseObject))
                                } else {
                                    if let errorMessages = dict["Message"] as? String{
                                        completion(.failure(.message(errorMessages)))
                                    }
                                    else {
                                        completion(.failure(.unKnown("Please Give Valid Data")))
                                    }
                                }
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                case .notFound:
                    
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let errorMessages = dict["errors"] as? NSDictionary, let key = errorMessages.allKeys.first as? String, let value = errorMessages[key] as? String {
                                completion(.failure(.message(value)))
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                case .serverError:
                    completion(.failure(.unKnown("Please Give Valid Data")))
                    
                case .tooManyAttempts:
                    completion(.failure(.tooManyAttemps))
                    
                case .unAuthorized:
                    completion(.failure(.unKnown("UnAuthorized")))
                    
                case .badRequest:
                    completion(.failure(.unKnown("Please Give Valid Data")))
                case .tokenExpired:
                    completion(.failure(.unKnown("Refresh token expired")))
                }
            }
        })
    }
}

