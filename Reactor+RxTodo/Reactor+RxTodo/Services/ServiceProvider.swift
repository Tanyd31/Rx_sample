//
//  ServiceProvider.swift
//  Reactor+RxTodo
//
//  Created by tanyadong on 2018/1/23.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

protocol ServiceProviderType: class {
    var userDefaulstService: UserDefaultsServiceType {get}
    var taskService: TaskServiceType {get}
}

final class ServiceProvider: ServiceProviderType {
    lazy var userDefaulstService: UserDefaultsServiceType = UserDefaultsService()
    lazy var taskService: TaskServiceType = TaskService(provider: self)
    
}
