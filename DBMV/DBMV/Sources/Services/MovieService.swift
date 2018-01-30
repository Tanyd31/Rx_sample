//
//  MovieService.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxSwift

enum Paging {
    case refresh
    case loadMore(Int)
}

protocol MovieServiceType {
    func movieTop250(paging: Paging) -> Single<List<Subject>>
    func movieSubject(id: String) -> Single<Subject>
}

final class MovieService: MovieServiceType {
    
    private let _networking: MVNetworking
    
    init(networking: MVNetworking = networking) {
        self._networking = networking
    }
    
    func movieTop250(paging: Paging) -> Single<List<Subject>> {
        var start = 0
        if case let .loadMore(page) = paging {
            start = page
        }
        return _networking.request(.top250(start)).mapObjectList(List<Subject>.self)
    }
    
    func movieSubject(id: String) ->  Single<Subject> {
        return _networking.request(.detail(id)).mapObject(Subject.self)
    }
    
}
