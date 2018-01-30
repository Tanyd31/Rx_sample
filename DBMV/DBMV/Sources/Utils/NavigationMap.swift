//
//  NavigationMap.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import URLNavigator

struct NavigationMap {
    static func initialize(navigator: NavigatorType) {
        navigator.register("myapp://movie/subject/<id>") { (url, values, context) in
            guard let id = values["id"] as? String else { return nil }
            let service = MovieService()
            return MovieViewController(reactor: MovieViewReactor(service: service, id: id))
        }
    }
}
