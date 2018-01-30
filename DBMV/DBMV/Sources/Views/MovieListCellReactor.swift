//
//  MovieListCellReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import ReactorKit

class MovieListCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var id: String
        var imageUrl: URL
        var title: String
        var ratingDouble: Double
        var ratingStr: String
        var content: String
    }
    
    var initialState: State
    
    let subject: Subject
    
    init(subject: Subject) {
        self.subject = subject
        initialState = State(id: subject.id,
                             imageUrl: subject.images.medium,
                             title: subject.title,
                             ratingDouble: subject.rating.average,
                             ratingStr: String(subject.rating.average),
                             content: subject.year + " / " +
                                      subject.genres.joined(separator: " ") + " / " +
                                      subject.casts.map { $0.name }.joined(separator: " "))
    }
    
}
