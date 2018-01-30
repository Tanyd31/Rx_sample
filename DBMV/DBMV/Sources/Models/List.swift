//
//  List.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation

struct List<Element>: ModelType {
    let title: String
    let count: Int
    let total: Int
    let start: Int
    let subjects: [Element]
    
    init(title: String, count: Int, total: Int, start: Int, subjects: [Element]) {
        self.title = title
        self.count = count
        self.total = total
        self.start = start
        self.subjects = subjects
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case count
        case total
        case start
        case subjects
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let count = try container.decode(Int.self, forKey: .count)
        let total = try container.decode(Int.self, forKey: .total)
        let start = try container.decode(Int.self, forKey: .start)
        let subjects = try container.decode([Element].self, forKey: .subjects)
        self.init(title: title, count: count, total: total, start: start, subjects: subjects)
    }
    
    func encode(to encoder: Encoder) throws { }
}
