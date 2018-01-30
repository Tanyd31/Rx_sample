//
//  Moya+Rx.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension PrimitiveSequence where TraitType == SingleTrait, Element == Moya.Response {

    func mapObject<T: ModelType>(_ type: T.Type) -> Single<T> {
        return map(T.self)
    }
    
    func mapObjectList<T: ModelType>(_ type: List<T>.Type) -> Single<List<T>> {
        return map(List<T>.self)
    }
}

