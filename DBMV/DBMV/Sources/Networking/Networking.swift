//
//  Networking.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import enum Result.Result

let networking = MVNetworking()

typealias MVNetworking = Networking<MovieAPI>

enum APIResult<T> {
    case success(T)
    case error(Error?)
    case empty
}

final class Networking<Target: TargetType>: MoyaProvider<Target> {
    
    private lazy var _manager: Manager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 5
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }()
    
    private lazy var networkActivityPlugin: NetworkActivityPlugin = NetworkActivityPlugin { change, _ in
        UIApplication.shared.isNetworkActivityIndicatorVisible = change == .began
    }
    
    init() {
        super.init(manager: _manager, plugins: [networkActivityPlugin])
    }
    
    func request(_ target: Target,
                 file: StaticString = #file,
                 function: StaticString = #function,
                 line: UInt = #line) -> Single<Response> {
        
        let requestString = "\(target.method) \(target.path) "

        return rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(onSuccess: {[weak self] (value) in
                guard let `self` = self else { return }
                let json = String(data: self.JSONResponseDataFormatter(value.data), encoding: .utf8) ?? ""
                let message = "SUCCESS: \(requestString) (\(value.statusCode)) " + json
                log.debug(message, file: file, function: function, line: line)
            }, onError: { (error) in
                let message = "FAILURE: \(requestString) \n\(error)"
                log.warning(message, file: file, function: function, line: line)
            }, onSubscribed: {
                let message = "REQUEST: \(requestString)"
                log.debug(message, file: file, function: function, line: line)
            })
    }
    
    
    // catch Error 
    func request2(_ target: Target,
                 file: StaticString = #file,
                 function: StaticString = #function,
                 line: UInt = #line) -> Single<APIResult<Response>> {
        
        return rx.request(target)
            .filterSuccessfulStatusCodes()
            .map({ reponse in
                return APIResult.success(reponse)
            }).catchError({ (error) in
                return Observable.of(APIResult.error(error)).asSingle()
            })
        }

    
    private func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
}

