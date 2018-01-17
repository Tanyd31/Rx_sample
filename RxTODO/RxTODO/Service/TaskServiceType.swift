//
//  TaskServiceType.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum TaskServiceError: Error {
    case creationFailed
    case updateFailed(TaskItem)
    case deletionFailed(TaskItem)
    case toggleFailed(TaskItem)
}


protocol TaskServiceType {
    
    @discardableResult
    func creatTask(with title: String) -> Observable<TaskItem>
    
    @discardableResult
    func updateTask(with task: TaskItem, title: String) -> Observable<TaskItem>
    
    @discardableResult
    func deleteTask(with task: TaskItem) -> Observable<Void>
    
    @discardableResult
    func toggleTask(with task: TaskItem) -> Observable<TaskItem>
    
    func tasks() -> Observable<Results<TaskItem>>
}
