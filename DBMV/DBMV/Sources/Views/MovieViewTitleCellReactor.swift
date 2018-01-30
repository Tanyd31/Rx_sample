//
//  MovieViewTitleCellReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import ReactorKit

class MovieViewTitleCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var title: String
        var content: String
        var ratingDouble: Double
        var ratingStr: String
        var ratingsCount: String
    }
    
    let subject: Subject

    var initialState: State
    
    init(subject: Subject) {
        self.subject = subject
        
        var content = subject.year + "\n"
        if let countries = subject.countries?.joined(separator: " ") {
            content += countries
            content += " / "
        }
        
        content += subject.genres.joined(separator: " / ") + "\n"
        
        if let originalTitle = subject.originalTitle {
            content += "原名: \(originalTitle)\n"
        }
        
        if let aka = subject.aka?.joined(separator: " / ") {
            content += "又名: \(aka)\n"
        }
        
        initialState = State(title: subject.title,
                                  content: content,
                                  ratingDouble: subject.rating.average,
                                  ratingStr: String(subject.rating.average),
                                  ratingsCount: "\(subject.ratingsCount ?? 0)人")
    }
    
}
