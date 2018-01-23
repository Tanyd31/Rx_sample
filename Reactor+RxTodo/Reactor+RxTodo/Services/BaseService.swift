//
//  BaseService.swift
//  Reactor+RxTodo
//
//  Created by tanyadong on 2018/1/23.
//  Copyright © 2018年 tanyadong. All rights reserved.
//


class BaseService {
    unowned var provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
}
