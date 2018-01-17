//
//  EditCoordinator.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/17.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift

enum EditTaskResult {
    case cancel
    case add((TaskItem?,String))
}

class EditCoordinator: BaseCoordinator<EditTaskResult> {
    
    private var root: UIViewController
    private var task: TaskItem?
    
    init(_ task: TaskItem? = nil , root: UIViewController) {
        self.root = root
        self.task = task
    }
    
    override func start() -> Observable<EditTaskResult> {
        var vc = EditTaskViewController.initialFromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        
        let viewModel = EditViewModel(task)
        let cancel = viewModel.didCancel.map { EditTaskResult.cancel }
        let add = viewModel.didAdd.map { EditTaskResult.add((self.task, $0)) }
        vc.bindViewModel(with: viewModel)
        
        root.present(nav, animated: true, completion: nil)
        
        return Observable.of(cancel,add)
            .merge()
            .take(1)
            .do(onNext: { [weak self] _ in
            self?.root.dismiss(animated: true, completion: nil)
        })
    }
}
