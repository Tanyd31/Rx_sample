//
//  TaskService.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct TaskService {
    
    static let share: TaskService = TaskService()

    init() {
        do {
            let realm = try Realm()
            if realm.objects(TaskItem.self).count == 0 {
                ["11111111",
                 "22222222",
                 "33333333",
                 "44444444",
                 "55555555"].forEach {
                    self.creatTask(with: $0)
                }
            }
        }catch _ { }
    }
}

extension TaskService: TaskServiceType {
    
    private func withRealm<T>(_ operation: String, action: (Realm) throws -> T ) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        }catch let error {
            print("\(operation) \(error)")
            return nil
        }
    }
    
    @discardableResult
    func creatTask(with title: String) -> Observable<TaskItem> {
        let result = withRealm("creat task") { realm -> Observable<TaskItem> in
            let task = TaskItem()
            task.title = title
            try realm.write {
                task.uid = (realm.objects(TaskItem.self).max(ofProperty: "uid") ?? 0) + 1
                realm.add(task)
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError.creationFailed)
    }
    
    @discardableResult
    func updateTask(with task: TaskItem, title: String) -> Observable<TaskItem> {
        let result = withRealm("update task") { realm -> Observable<TaskItem> in
            try realm.write {
                task.title = title
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError.updateFailed(task))
    }
    
    @discardableResult
    func deleteTask(with task: TaskItem) -> Observable<Void> {
        let result = withRealm("delete task") { realm -> Observable<Void> in
            try realm.write {
                realm.delete(task)
            }
            return .empty()
        }
        return result ?? .error(TaskServiceError.deletionFailed(task))
    }
    
    @discardableResult
    func toggleTask(with task: TaskItem) -> Observable<TaskItem> {
        let result = withRealm("toggle task") { realm -> Observable<TaskItem> in
            try realm.write {
                if task.checked == nil {
                    task.checked = Date()
                }else {
                    task.checked = nil
                }
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError.toggleFailed(task))
    }
    
    @discardableResult
    func tasks() -> Observable<Results<TaskItem>> {
        let result = withRealm("tasks") { realm -> Observable<Results<TaskItem>> in
            let tasks = realm.objects(TaskItem.self)
            return Observable.collection(from: tasks)
        }
        return result ?? .empty()
    }
    
}
