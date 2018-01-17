//
//  LanguagesCoordinator.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift

enum LanguageListCoordinationResult {
    case language(String)
    case cancel
}

class LanguagesListCoordinator: BaseCoordinator<LanguageListCoordinationResult> {
    
    private var root: UIViewController
    
    init(_ root: UIViewController) {
        self.root = root
    }
    
    override func start() -> Observable<LanguageListCoordinationResult> {
        let vc = LanguagesListViewController.fromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        
        let viewModel = LanguagesListViewModel()
        vc.viewModel = viewModel
        
        let cancel = viewModel.didCancel.map { LanguageListCoordinationResult.cancel }
        let selectLanguage = viewModel.didSelectLanguage.map { LanguageListCoordinationResult.language($0) }
        
        root.present(nav, animated: true, completion: nil)
        
        return Observable.merge(cancel, selectLanguage)
            .take(1)
            .do(onNext: { [weak self] _ in self?.root.dismiss(animated: true)})
    }
}
