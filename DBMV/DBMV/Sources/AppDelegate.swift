//
//  AppDelegate.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/25.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import URLNavigator

let navigator = Navigator()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var disposeBag: DisposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NavigationMap.initialize(navigator: navigator)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let service = MovieService()
        let movieListReactor = MovieListViewReactor(service: service)
        let movieListVC = MovieListViewController(reactor: movieListReactor)
        let nav = UINavigationController(rootViewController: movieListVC)
        window?.rootViewController = nav

        return true
    }

}

