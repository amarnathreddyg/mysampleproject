//
//  ViewController.swift
//  PaperTrails
//
//  Created by Amarnath on 31/01/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//
import UIKit
//import Unbox

class ApiManager {
    
    static let shared = ApiManager()
    
    fileprivate init() { }
    
    fileprivate class func getResponseErrorWithStatusCode(_ statusCode:Int?) -> ResponseError {
        
        if let statusCode_ = statusCode {
            switch statusCode_ {
            case ResponseStatusCode.notFound.rawValue:
                return ResponseError.notFoundError
            case ResponseStatusCode.badRequest.rawValue:
                return ResponseError.badRequestError
            case ResponseStatusCode.timeout.rawValue:
                return ResponseError.timeoutError
            case ResponseStatusCode.internalServer.rawValue:
                return ResponseError.internalServerError
            default:
                return ResponseError.unkonownError
            }
        }
        return ResponseError.unkonownError
        
    }
    
    func dataTask(_ request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            let response = response as? HTTPURLResponse
            //debugPrint(response?.statusCode ?? "")
            if let data_ = data, data_.count != 0 {
                do  {
                    let json = try JSONSerialization.jsonObject(with: data_, options: .mutableContainers)
                    if let json_ = json as? [String: AnyObject] {
                        if json_["success"] as? String == "1" || json_["success"] as? NSNumber == 1 || json_["success"] as? Bool == true {
                            completion(true, json_ as AnyObject?)
                        } else {
                            completion(false, json_ as AnyObject?)
                        }
                    } else if let json_ = json as? [AnyObject] {
                        completion(true, json_ as AnyObject?)
                    }
                } catch {
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }
        dataTask.resume()
    }

    private func post(_ path: String, params: AnyObject? = nil, shouldUploadImage: Bool? = nil, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        let request = clientURLRequest(path, params: params, method: .post, shouldUploadImage: shouldUploadImage)
        dataTask(request, completion: completion)
    }
    
    
    private func put(_ path: String, params: AnyObject? = nil, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        let request = clientURLRequest(path, params: params, method: .put)
        dataTask(request, completion: completion)
    }
    
    private func get(_ path: String, params: AnyObject? = nil, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        let request = clientURLRequest(path, params: params, method: .get)
        dataTask(request, completion: completion)
    }

    private func clientURLRequest(_ path: String, params: AnyObject? = nil, method: NetworkMethod, shouldUploadImage: Bool? = nil) -> NSMutableURLRequest {
        
        let baseURLString = "\(baseUrl)\(path)"
        let request = NSMutableURLRequest(url: URL(string: baseURLString)! as URL)
        request.httpMethod = method.rawValue
        if let _params = params {
            switch method {
            case .post, .put:
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: _params, options: JSONSerialization.WritingOptions.prettyPrinted)
                    request.httpBody = jsonData
                } catch let error as NSError {
                    debugPrint(error)
                }
                break
            case .get:
                request.url =  formURL(baseURLString, paramDict: _params as! Dictionary<String, AnyObject>)!
                break
            }
        }
        //add headers
        
        if shouldUploadImage == nil {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            if(Utilities.getAuthToken() != "") {
                request.addValue(Utilities.getAuthToken(), forHTTPHeaderField: "x-access-token")
            }
//            request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZV9udW1iZXIiOiI5Njg2NTY3NjE2Iiwicm9sZSI6InBhcmVudCIsImlhdCI6MTQ4NjAzMzI0MSwiZXhwIjoxNDg4NjI1MjQxfQ.fpyCRYKeUH-f4yA2l7LmBIM8hT7tir6XqZ8U41FzQW0", forHTTPHeaderField: "x-access-token")
        }
        return request
    }
    
    private func formURL(_ base: String, paramDict: Dictionary<String, AnyObject>) -> URL? {
        
        var urlComponents = URLComponents(string: base)!
        var queryItems = [URLQueryItem]()
        for (key, value) in paramDict {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        urlComponents.queryItems = queryItems as [URLQueryItem]?
        return urlComponents.url
    }
    
    func login(email: String, password: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        let loginObject = ["email": email, "password": password]
        post(URI.login.rawValue, params: loginObject as AnyObject?, completion: completion)
    }
    
    func register(phoneNumber: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        let loginObject = ["role": "parent", "phone_number": phoneNumber]
        post(URI.login.rawValue, params: loginObject as AnyObject?, completion: completion)
    }
    
    
    func getTrips(isHistory: Bool, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        var params: [String: String]?
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.timeZone = TimeZone.current
        components.day = components.day! - 1
        components.hour = 23
        components.minute = 59
        let utcDate = Calendar.current.date(from: components)
        let timeZoneSeconds = TimeZone.current.secondsFromGMT()
        let localDate = utcDate?.addingTimeInterval(TimeInterval(timeZoneSeconds))
        let timeStamp = localDate?.timeIntervalSince1970
        let value = "\(Int(timeStamp!*1000))"
        if isHistory {
            params = ["before": value]
        }
        /*else {
            params = ["after": value]
        }*/
        get(URI.trips.rawValue, params: params as AnyObject?, completion: completion)
    }

    func getTrip(tripId: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        get(URI.trips.rawValue + "/\(tripId)", params: nil, completion: completion)
    }
    
    func getChild(completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        get(URI.child.rawValue, params: nil, completion: completion)
    }

    func postChild(childId: String, alertType: String, alertValue: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        let params = ["alert_type": alertType, "alert_value": alertValue, "_id": childId]
        post(URI.child.rawValue, params: params as AnyObject?, completion: completion)
    }
    
}

