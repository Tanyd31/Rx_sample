//
//  APIManager.swift
//  Moya+Rx
//
//  Created by tanyadong on 2018/1/18.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import enum Result.Result

// http://www.pm25.in/api/querys/pm2_5.json?city=上海 -> success
// http://www.pm25.in/api/querys/pm2_5.json?city=可可西里 -> error

enum APIManager {
    
    case pm2_5(String)
}

extension APIManager: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://www.pm25.in/api/querys")!
    }
    
    var path: String {
        switch self {
        case .pm2_5:
            return "pm2_5.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .pm2_5:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .pm2_5(let city):
            return .requestParameters(parameters: ["city":city.utf8,
                                                   "token":"5j1znBVAsnSf5xQyNQyq"],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


//MARK: endpointClosure, Target -> Endpoint

// 可以增加一些共同的headers
let endpointClosure = { (target: APIManager) -> Endpoint<APIManager> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(newHTTPHeaderFields: ["APP_NAME": "MY_AWESOME_APP"])
}


//MARK: requestClosure, Endpoint -> Request

let requestClosure = { (endpoint: Endpoint<APIManager>, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 做OAuth签名或者别的什么
        // 禁用所有请求的cookie
        request.httpShouldHandleCookies = false
        // 设置超时：
        request.timeoutInterval = 5
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

//MARK: stubClosure

/*
 这个闭包返回 .never (默认的), .immediate 或者可以把stub请求延迟指定时间的.delayed(seconds)三个中的一个。
 例如, .delayed(0.2) 可以把每个stub 请求延迟0.2s.
 这个在单元测试中来模拟网络请求是非常有用的。
 */


//MARK: manager

/*
 一个基本配置的自定义的Alamofire.Manager实例对象
 */

// 设置忽略SSL验证
let managerClosure = { () -> Manager in
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    let policies: [String: ServerTrustPolicy] = [
        "baidu.com": .disableEvaluation
    ]
    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
    manager.startRequestsImmediately = false
    return manager
}


//MARK: plugins 🐼🐼🐼
/*
 (prepare) Moya 已经分解 TargetType 成 URLRequest之后被执行. 这是请求被发送前进行编辑的一个机会 (例如 添加 headers).
 (willSend) 请求将要发送前被执行. 这是检查请求和执行任何副作用(如日志)的机会。
 (didReceive) 接收到一个响应后被执行. 这是一个检查响应和执行副作用的机会。
 (process) 在 completion 被调用前执行. 这是对request的Result进行任意编辑的一个机会。
 */

// 网络指示器插件
// 可以根据target判断请求类型，比如上传的时候就直接返回，不执行插件
let networkActivityPlugin = NetworkActivityPlugin { change, target  -> () in
    switch change {
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
}

// NetworkLoggerPlugin日志打印插件
// 在这里可以自定义打印的formatter
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true,responseDataFormatter: JSONResponseDataFormatter)


//CredentialsPlugin 身份验证插件
// 身份验证插件允许用户给每个请求赋值一个可选的 URLCredential 。当收到请求时，没有操作


// 处理 error 插件
struct NetworkErrorsPlugin: PluginType {
    
    /// Called immediately before a request is sent over the network (or stubbed).
    func willSendRequest(request: RequestType, target: TargetType) { }
    
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceiveResponse(result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
        let responseJSON: AnyObject
        if let response = result.value {
            do {
//                responseJSON = try response.mapJSON() as AnyObject
//                if let response = Mapper<GeneralServerResponse>().map(responseJSON) {
//                    switch response.status {
//                    case .Failure(let cause):
//                        if cause == "Not valid Version" {
//                            print("Version Error")
//                        }
//                    default:
//                        break
//                    }
//                }
            } catch {
                print("Falure to prase json response")
            }
        } else {
            print("Network Error = \(String(describing: result.error))")
        }
    }
}
