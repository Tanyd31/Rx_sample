//
//  ActorCellReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import ReactorKit

class ActorCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var imageURL: URL?
        var name: String
    }
    
    var initialState: State

    var actor: Casts
    
    init(actor: Casts) {
        self.actor = actor
        initialState = State(imageURL: actor.avatars?.small, name: actor.name)
    }
}
