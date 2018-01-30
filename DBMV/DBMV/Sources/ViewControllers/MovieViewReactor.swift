//
//  MovieViewReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class MovieViewReactor: Reactor {
    
    enum Action {
        case refresh
    }

    enum Mutation {
        case setRefreshing(Bool)
        case setSubject(Subject)
    }
    
    struct State {
        var isRefreshing: Bool = false
        var sections: [MovieViewSection] = []
        var title: String = ""
    }
    
    var initialState = State()
    
    fileprivate let service: MovieServiceType
    
    fileprivate let id: String
    
    init(service: MovieServiceType, id: String) {
        self.service = service
        self.id = id
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([Observable.just(.setRefreshing(true)),
                                      service.movieSubject(id: id)
                                        .asObservable()
                                        .map(Mutation.setSubject),
                                      Observable.just(.setRefreshing(false))])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRefreshing(refresh):
            newState.isRefreshing = refresh
        case let .setSubject(subject):
            let img = MovieViewSectionItem.image(MovieViewImageCellReactor(subject: subject))
            let title = MovieViewSectionItem.title(MovieViewTitleCellReactor(subject: subject))
            let summary = MovieViewSectionItem.summary(MovieViewSummaryCellReactor(subject: subject))
            let actors = MovieViewSectionItem.actors(MovieViewActorsCellReactor(subject: subject))
            newState.sections = [MovieViewSection.content([img,title,summary,actors])]
            newState.title = subject.title
        }
        return newState
    }
}

