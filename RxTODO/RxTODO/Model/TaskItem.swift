//
//  TaskItem.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class TaskItem: Object {
    dynamic var uid: Int = 0
    dynamic var title: String = ""
    
    dynamic var added: Date = Date()
    dynamic var checked: Date? = nil
    
    override class func primaryKey() -> String? {
        return "uid"
    }
}


extension TaskItem: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        return self.isInvalidated ? 0 : uid
    }
}
