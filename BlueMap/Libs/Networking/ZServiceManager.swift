//
//  ZServiceManager.swift
//  BlueMap
//
//  Created by Vinh on 7/1/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import Foundation
import ObjectMapper

class ZServiceDataSource {
    var method      : ZServiceMethod!
    var url         : String!
    var headers     : [String: String]? = nil
    var parameters  : [String: Any] = [:]
    var isValidate  : Bool = true
    
    required init() {}
}

class ZServiceNavigation {
    var errors: [Any]?
    var validationErrors: [Any]?
    var warnings: [Any]?
    var infors: [Any]?
}

public enum ZServiceMethod: String {
    case GET, POST, UPLOAD
}

enum ZServiceResponseError: Int {
    case networkError = -1
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired  = 402
    case forbidden = 403
    case internalError = 500
    case notFound = 404
    case internetOffline = 1009
    case unknown
}

class ZServiceResponseData {
    
    var response: Any?
    var error: ZServiceResponseError?
    
    
    init(_ response: Any?, error: ZServiceResponseError? = nil) {
        self.error = error
        
        if let _response = response as? [String : Any] {
            if let _dataResponse = _response["data"]  {
                self.response = _dataResponse
            }
        }
    }
}

// MARK: - Networking wapper
class ZServiceManager {
    
    static let networking = ZNetworking()
    
    @discardableResult class func request(_ dataSource: ZServiceDataSource, completion: @escaping ((_ data: ZServiceResponseData) -> Void))  -> URLSessionTask? {
        let method: ZServiceMethod = dataSource.method
        switch method {
        case .POST:
            dataSource.url = "https://private-aa508-treatsure.apiary-mock.com/questions"
            dataSource.parameters = ["questions": "Favourite programming language?"]
//            debugPrint(dataSource.url)
            return ZServiceManager.networking.POST(dataSource.url, parameters: dataSource.parameters) {
                (responseObject) in
//                debugPrint(responseObject)
                switch responseObject {
                case .success(let response):
                    return completion(ZServiceResponseData(response, error: nil))
                case .failure(let errorCode):
                    completion(ZServiceResponseData(nil ,error: ZServiceResponseError(rawValue: errorCode)))
                default:
                    completion(ZServiceResponseData(nil,error: ZServiceResponseError(rawValue: -1)))
                }
            }
        case .GET:
            debugPrint(dataSource.url)
            return ZServiceManager.networking.GET(dataSource.url,headers: dataSource.headers, parameters: dataSource.parameters ) { (responseObject) in
                debugPrint(responseObject)
                switch responseObject {
                case .success(let response):
                    return completion(ZServiceResponseData(response,  error: nil))
                case .failure(let errorCode):
                    completion(ZServiceResponseData(nil,error: ZServiceResponseError(rawValue: errorCode)))
                default:
                    completion(ZServiceResponseData(nil, error: ZServiceResponseError(rawValue: -1)))
                }
            }
        case .UPLOAD:
            return ZServiceManager.networking.UPLOAD(
                dataSource.url,
                headers: dataSource.headers,
                parameters: dataSource.parameters,
                completion: { (responseObject) in
                    switch responseObject {
                    case .success(let response):
                        return completion(ZServiceResponseData(response, error: nil))
                    case .failure(let errorCode):
                        
                        completion(ZServiceResponseData(nil, error: ZServiceResponseError(rawValue: errorCode)))
                    default:
                        completion(ZServiceResponseData(nil,  error: ZServiceResponseError(rawValue: -1)))
                    }
            })
            
        }
    }
}


