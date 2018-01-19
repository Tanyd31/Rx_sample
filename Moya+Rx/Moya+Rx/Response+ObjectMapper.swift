//
//  Response+ObjectMapper.swift
//  Moya+Rx
//
//  Created by tanyadong on 2018/1/18.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper


enum CustomAPICodeError: Error {
    case _400
    case _401
    case _402
    case _499
}

extension CustomAPICodeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case ._400:
            return "一些自定义的错误"
        default:
            return "一些自定义的错误2"
        }
    }
}

extension Response {
    
    func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let obj = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return obj
    }
    
    func mapObjects<T: BaseMappable>(_ type: T.Type) throws -> [T] {
        guard let json = try mapJSON() as? [[String : Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        
        guard let objs = Mapper<T>().mapArray(JSONObject: json) else {
            throw MoyaError.jsonMapping(self)
        }
        return objs
    }
    
    func filterCustomErrorCode() throws -> Response {
        guard !(200...299).contains(statusCode) else {
            return self
        }
        switch statusCode {
        case 400:
            throw CustomAPICodeError._400
        case 401:
            throw CustomAPICodeError._401
        case 402:
            throw CustomAPICodeError._402
        case 499:
            throw CustomAPICodeError._499
        default:
            return self
        }
    }

}


extension ObservableType where E == Response {
    
     func mapObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
     func mapObjects<T: BaseMappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapObjects(T.self))
        }.catchErrorJustReturn([])
    }
    
    func filterCustomErrorCode() -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.filterCustomErrorCode())
        }
    }

}
