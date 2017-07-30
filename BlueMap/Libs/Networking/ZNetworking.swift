//
//  ZNetworking.swift
//  BlueMap
//
//  Created by Vinh on 7/1/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import Foundation
import Alamofire

/**
 Result for request response
 
 - Success:  Success
 - Failure:  Failure
 - Cancel:   Cancel
 - NotFound: NotFound
 */
public enum Result<T: Any> {
    case success(T?)
    case failure(Int)
    case cancel(T?)
    case notFound(T?)
}

class ZNetworking {
    
    var request: Alamofire.Request?
    
    class func handleStatusCode(_ status: Int) {
        switch status {
        case 401:
            Log.error("Handle StatusCode 401: Not Authenticate (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        case 417:
            Log.error("Handle StatusCode 417: Expectation Failed (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        case 404:
            Log.error("Handle StatusCode: 404 Not Found (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
        case -1009:
            Log.error("Handle StatusCode: -1009 The Internet connection appears to be offline.")
            break
        default:
            Log.error("Handle StatusCode: ",status)
            break
        }
    }
    
    func UPLOAD(_ url: String, headers: [String: String]? = nil , parameters: [String: Any]? = nil, files: [String: String]? = nil, completion: @escaping ((_ responseObject: Result<Any>) -> Void)) -> URLSessionTask? {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let params = parameters {
                for param in params {
                    multipartFormData.append("\(param.1)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: param.0)
                }
            }
            if let files  = files {
                for file in files {
                    multipartFormData.append(URL.init(fileURLWithPath: file.1), withName: file.0)
                }
            }
        }, usingThreshold: (100 * 1024 * 1024), to: url, method: Alamofire.HTTPMethod.post, headers: headers) { (multipartFormDataEncodingResult) in
            switch multipartFormDataEncodingResult {
            case .success(request: let _request, streamingFromDisk: _, streamFileURL: _):
                Log.debug("Request:", _request)
                self.request = _request
                _request.responseJSON { (responseObject) in
                    switch responseObject.result {
                    case .success(let result):
                        return completion(Result.success(result))
                    case .failure(let error):
                        Log.error("FAILD UPLOAD 0:", error)
                        return completion(Result.failure(responseObject.response?.statusCode ?? -1))
                    }
                }
                break
            case .failure(let error):
                Log.error("FAILD UPLOAD 1:", error)
                return completion(Result.failure(-1))
            }
        }
        return self.request?.task
    }
    
    func POST(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? , completion: @escaping ((_ responseObject: Result<Any>) -> Void)) -> URLSessionTask? {
        self.request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<303)
            .responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                completion(Result.success(response.result.value))
            } else {
                Log.debug("Request POST Faild Link: ", self.request?.request?.url?.absoluteString as Any)
                Log.debug("Request POST Faild Response: ", response)
                Log.debug("Request POST Faild Response Error Code: ", response.response?.statusCode as Any)
                if let response = response.response {
                    completion(Result.failure(response.statusCode))
                } else {
                    completion(Result.failure(-1))
                }
            }
        })
        return self.request?.task
    }
    
    func GET(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? , completion: @escaping ((_ responseObject: Result<Any>) -> Void)) -> URLSessionTask? {
        self.request = Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<303)
            .responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
//                Log.debug("Request GET Success Link: ", self.request?.request?.url?.absoluteString as Any)
//                Log.debug("Request GET Success Response: ", response)
//                Log.debug("Request GET Success Response Success Code: ", response.response?.statusCode as Any
//                )
                completion(Result.success(response.result.value))
            } else {
                Log.debug("Request GET Faild Link: ", self.request?.request?.url?.absoluteString as Any)
                Log.debug("Request GET Faild Response: ", response)
                Log.debug("Request GET Faild Response Error Code: ", response.response?.statusCode as Any
                )
                if let response = response.response {
                    completion(Result.failure(response.statusCode))
                } else {
                    completion(Result.failure(-1))
                }
            }
        })
        return self.request?.task
    }
    
    func cancelTask(_ task: URLSessionDataTask) {
        task.cancel()
    }
    
    func cancelTask() {
        self.request?.task?.cancel()
    }
    
}
