//
//  AppCoordinator.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit

import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private var window: UIWindow!
    
    init(with window: UIWindow) {
        self.window = window
    }
 
    override func start() -> Observable<Void> {
        let task = TasksCoordinator(window)
        return coordinate(to: task)
    }
}
