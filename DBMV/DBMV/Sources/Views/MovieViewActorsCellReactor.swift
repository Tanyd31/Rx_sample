//
//  MovieViewActorsCellReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import ReactorKit

class MovieViewActorsCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var sections: [ActorsSection] = []
    }
    
    var initialState: State
    
    let subject: Subject

    init(subject: Subject) {
        self.subject = subject
        let items = (subject.directors ?? []) + subject.casts
        initialState = State(sections: [ActorsSection(model: Void(),
                                                      items: items.map(ActorCellReactor.init))])
    }
}
