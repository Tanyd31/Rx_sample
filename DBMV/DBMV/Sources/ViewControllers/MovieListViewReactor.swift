//
//  MovieListViewReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class MovieListViewReactor: Reactor {
  
    enum Action {
        case refresh
        case loadMore
        case selectedItem(MovieListCellReactor)
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setMovies([Subject])
        case appendMovies([Subject])
        case selectedID(String)
    }
    
    struct State {
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var sections: [MovieListSection] = []
        var nextPage: Int?
        var selectedID: String?
    }
    
    var initialState: State = State()

    fileprivate let service: MovieServiceType
    
    init(service: MovieServiceType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        guard !currentState.isRefreshing else { return .empty() }
        guard !currentState.isLoading else { return .empty() }
        
        switch action {
        case .refresh:
            return Observable.concat([.just(.setRefreshing(true)),
                                      service.movieTop250(paging: .refresh)
                                        .asObservable()
                                        .map { .setMovies($0.subjects) },
                                      .just(.setRefreshing(false))])
                .catchErrorJustReturn(.setRefreshing(false))
            
        case .loadMore:
            guard let nextPage = currentState.nextPage else { return .empty() }
            return Observable.concat([.just(.setLoading(true)),
                                      service.movieTop250(paging: .loadMore(nextPage))
                                        .asObservable()
                                        .map { .appendMovies($0.subjects) },
                                      .just(.setLoading(false))])
                .catchErrorJustReturn(.setLoading(false))
        
        case let .selectedItem(reactor):
            let id = reactor.currentState.id
            return Observable.just(Mutation.selectedID(id)).do(onNext: { _ in
                navigator.push("myapp://movie/subject/\(id)")
            })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRefreshing(refresh):
            newState.isRefreshing = refresh
        case let .setLoading(loading):
            newState.isLoading = loading
        case let .setMovies(movies):
            newState.sections = [MovieListSection(model: Void(), items: movies.map(MovieListCellReactor.init))]
            newState.nextPage = newState.sections[0].items.count
        case let .appendMovies(movies):
            let items = newState.sections[0].items + movies.map(MovieListCellReactor.init)
            newState.sections = [MovieListSection(model: Void(), items: items)]
            newState.nextPage = newState.sections[0].items.count
        case let .selectedID(id):
            newState.selectedID = id
        }
        return newState
    }
}
