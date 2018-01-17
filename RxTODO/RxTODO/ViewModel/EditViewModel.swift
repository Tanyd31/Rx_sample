//
//  EditViewModel.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxSwift

class EditViewModel {
    
    //MARK: input
    let add: AnyObserver<String>
    
    let cancel: AnyObserver<Void>
    
    //MARK: output
    let didAdd: Observable<String>
    
    let didCancel: Observable<Void>
    
    private var task: TaskItem?
    
    var taskTitle: String?
    
    init(_ task: TaskItem?) {
        
        self.task = task
        taskTitle = task?.title
        
        let _add = PublishSubject<String>()
        add = _add.asObserver()
        didAdd = _add.asObservable()
        
        let _cancel = PublishSubject<Void>()
        cancel = _cancel.asObserver()
        didCancel = _cancel.asObservable()
    }
}
