//
//  MovieViewSummaryCellReactor.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import ReactorKit

class MovieViewSummaryCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var summary: NSAttributedString
    }
    
    var initialState: State
    
    var subject: Subject

    init(subject: Subject) {
        self.subject = subject
        let summary = NSMutableAttributedString(string: subject.summary ?? "暂无")
        summary.yy_font = UIFont.systemFont(ofSize: 13)
        initialState = State(summary: summary)
    }
    
}
