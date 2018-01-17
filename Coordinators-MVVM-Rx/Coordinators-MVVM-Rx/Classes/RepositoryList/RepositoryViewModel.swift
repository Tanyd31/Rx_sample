//
//  RepositoryViewModel.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation

class RepositoryViewModel {
    let name: String
    let description: String
    let starsCountText: String
    let url: URL
    
    init(repository: Repository) {
        self.name = repository.fullName
        self.description = repository.description
        self.starsCountText = "⭐️ \(repository.starsCount)"
        self.url = URL(string: repository.url)!
    }
}
