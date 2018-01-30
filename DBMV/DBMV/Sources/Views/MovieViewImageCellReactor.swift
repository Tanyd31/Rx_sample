//
//  MovieViewImageCellReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import ReactorKit

class MovieViewImageCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var imageURL: URL
    }
    
    let subject: Subject
    
    var initialState: State
    
    init(subject: Subject) {
        self.subject = subject
        initialState = State(imageURL: subject.images.large)
    }
}
