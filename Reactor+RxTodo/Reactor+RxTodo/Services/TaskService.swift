//
//  TaskService.swift
//  Reactor+RxTodo
//
//  Created by tanyadong on 2018/1/23.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import RxSwift

enum TaskEvent {
    case creat(Task)
    case update(Task)
    case delete(Task)
    case move(id: String, to: Int)
    case makeAsDone(id: String)
    case makeAsUndonw(id: String)
}


protocol TaskServiceType {
    var event: PublishSubject<TaskEvent> {get}
    
    func fetchTasks() -> Observable<[Task]>
    
    @discardableResult
    func saveTasks(task: [Task]) -> Observable<Void>

    func creat(title: String, memo: String?) -> Observable<Task>
    func update(id: String, title: String, memo: String?) -> Observable<Task>
    func delete(id: String) -> Observable<Task>
    func move(id: String, to: Int) -> Observable<Task>
    func makeAsDone(id: String) -> Observable<Task>
    func makeAsUndone(id: String) -> Observable<Task>
}


final class TaskService: BaseService, TaskServiceType  {
    
    let event = PublishSubject<TaskEvent>()

    func fetchTasks() -> Observable<[Task]> {
        if let savedTaskDictionaries = self.provider.userDefaulstService.value(forKey: .task) {
            let tasks = savedTaskDictionaries.flatMap (Task.init)
            return .just(tasks)
        }
        
        let defaultTasks: [Task] = [
            Task(title: "Go to https://github.com/devxoul"),
            Task(title: "Star repositories I am intersted in"),
            Task(title: "Make a pull request"),
            ]
        let defaultTaskDictionaries = defaultTasks.map { $0.asDictionary() }
        self.provider.userDefaulstService.set(value: defaultTaskDictionaries, forKey: .task)
        return .just(defaultTasks)
    }
    
    func saveTasks(task: [Task]) -> Observable<Void> {
        <#code#>
    }

    func creat(title: String, memo: String?) -> Observable<Task> {
        <#code#>
    }

    func update(id: String, title: String, memo: String?) -> Observable<Task> {
        <#code#>
    }

    func delete(id: String) -> Observable<Task> {
        <#code#>
    }

    func move(id: String, to: Int) -> Observable<Task> {
        <#code#>
    }

    func makeAsDone(id: String) -> Observable<Task> {
        <#code#>
    }

    func makeAsUndone(id: String) -> Observable<Task> {
        <#code#>
    }
    
   
    
}
