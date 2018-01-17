//
//  RepositoryListCoordinator.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class RepositoryListCoordinator: BaseCoordinator<Void> {
    
    private var window: UIWindow
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let vc = RepositoryListViewController.fromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        
        let viewModel = RepositoryListViewModel("Swift")
        vc.viewModel = viewModel
        
        viewModel.showRepository.subscribe(onNext: { [unowned self] in
            self.showRepository(by: $0, in: nav)
        }).disposed(by: disposeBag)
        
        viewModel.showLanguageList.flatMapLatest { [weak self] _ -> Observable<String?> in
            guard let `self` = self else { return .empty() }
            return self.showLanguageList(on: vc)
        }.filter { $0 != nil }
        .map { $0! }
        .bind(to: viewModel.setCurrentLanguage)
        .disposed(by: disposeBag)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
        // 根控制器永远在
        return Observable.never()
    }
    
    private func showRepository(by url: URL, in navigationController: UINavigationController) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController.pushViewController(safariViewController, animated: true)
    }
    
    private func showLanguageList(on root: UIViewController) -> Observable<String?> {
        let language = LanguagesListCoordinator(root)
        return coordinate(to: language).map({ (result) -> String? in
            switch result {
            case .language(let language): return language
            case .cancel: return nil
            }
        })
    }
}
