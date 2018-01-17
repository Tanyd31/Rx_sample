//
//  TaskViewModel.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

typealias TaskSection = AnimatableSectionModel<String,TaskItem>

class TaskViewModel {
  
    //MARK: input
    let add: AnyObserver<Void>
    
    let selectTask: AnyObserver<TaskItem>
    
    let toggle: AnyObserver<TaskItem>
    
    //MARK: output
    let didAdd: Observable<Void>
    
    let didAddTask: AnyObserver<String?>
    
    let didSelectTask: Observable<TaskItem>
    
    let didUpadteTask: AnyObserver<(TaskItem,String)>

    let didToggle: Observable<TaskItem>
    
    //MARK: other
    var service: TaskService!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var sections: Driver<[TaskSection]> {
        return service.tasks().map { tasks in
            let dueTasks = tasks.filter("checked == nil")
                .sorted(byKeyPath: "added", ascending: false)
                .toArray()
            
            let doneTasks = tasks.filter("checked != nil")
                .sorted(byKeyPath: "checked", ascending: false)
                .toArray()
            
            return [TaskSection(model: "dueTasks", items: dueTasks),
                    TaskSection(model: "doneTasks", items: doneTasks)]
        }.asDriver(onErrorJustReturn: [])
    }
    
    init(_ service: TaskService = TaskService.share) {
        self.service = service
        
        let _add = PublishSubject<Void>()
        add = _add.asObserver()
        didAdd = _add.asObservable()
        
        let _selectTask = PublishSubject<TaskItem>()
        selectTask = _selectTask.asObserver()
        didSelectTask = _selectTask.asObservable()
        
        let _toggle = PublishSubject<TaskItem>()
        toggle = _toggle.asObserver()
        didToggle = _toggle.asObservable()
        
        didAddTask = AnyObserver<String?> { event in
            switch event {
            case .next(let title):
                if let _title = title {
                    service.creatTask(with: _title)
                }
            default: break
            }
        }
        
        didUpadteTask = AnyObserver<(TaskItem,String)> { event in
            switch event {
            case .next(let item):
                service.updateTask(with: item.0, title: item.1)
            default: break
            }
        }
        
        didToggle.subscribe(onNext: { task in
            service.toggleTask(with: task)
        }).disposed(by: disposeBag)
        
    }
}
