//
//  MovieAPI.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import Moya

enum MovieAPI {
    case top250(Int)
    case detail(String)
}

extension MovieAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.douban.com/v2/movie/")!
    }
    
    var path: String {
        switch self {
        case .top250:
            return "top250"
        case let .detail(id):
            return "subject/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .top250(start):
            return .requestParameters(parameters: ["start":start], encoding: URLEncoding.default)
        case .detail:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
 
}
