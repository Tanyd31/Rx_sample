//
//  TasksCoordinator.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift

class TasksCoordinator: BaseCoordinator<Void> {
    
    private var window: UIWindow!

    init(_ window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        var vc = TasksViewController.initialFromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        
        let viewModel = TaskViewModel()
        
        viewModel.didAdd
            .flatMap { self.toEditViewController(root: vc) }
            .map { $0?.1 }
            .subscribe(viewModel.didAddTask)
            .disposed(by: disposeBag)
      
        viewModel.didSelectTask
            .flatMap { self.toEditViewController($0, root: vc) }
            .filter { $0 != nil }
            .map { ($0!.0!,$0!.1) }
            .subscribe(viewModel.didUpadteTask)
            .disposed(by: disposeBag)

        vc.bindViewModel(with: viewModel)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        return .never()
    }
    
    private func toEditViewController(_ task: TaskItem? = nil, root: UIViewController) -> Observable<(TaskItem?,String)?>{
        let edit = EditCoordinator(task, root: root)
        return coordinate(to: edit).map { (result) -> (TaskItem?,String)? in
            switch result{
            case .add(let task):
                return task
            case .cancel:
                return nil
            }
        }.share(replay: 1)
    }
}
