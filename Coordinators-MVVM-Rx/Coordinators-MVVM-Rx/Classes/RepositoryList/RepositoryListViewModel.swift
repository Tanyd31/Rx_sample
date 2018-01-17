//
//  RepositoryListViewModel.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoryListViewModel {
    
    //MARK: input 监听UI操作
    
    // 设置选中的语言
    let setCurrentLanguage: AnyObserver<String>
 
    // 点击右上角语言列表按钮
    let chooseLanguage: AnyObserver<Void>

    // 选中一个仓库
    let selectRepository: AnyObserver<RepositoryViewModel>
    
    // 刷新
    let reload: AnyObserver<Void>
    
    //MARK: output
    
    // 所有的repository
    let repositoies: Driver<[RepositoryViewModel]>

    // 跳转语言列表页面
    let showLanguageList: Observable<Void>
    
    // 跳转一个仓库
    let showRepository: Observable<URL>

    // repositoryList title
    let title: Observable<String>
    
    let alertMessage: Observable<String>

    init(_ initialLanguage: String, service: GithubService = GithubService.share) {
        
        let _currentLanguage = BehaviorSubject<String>(value: initialLanguage)
        setCurrentLanguage = _currentLanguage.asObserver()
        
        let _chooseLanguage = PublishSubject<Void>()
        chooseLanguage = _chooseLanguage.asObserver()
        showLanguageList = _chooseLanguage.asObservable()
        
        let _selectRepository = PublishSubject<RepositoryViewModel>()
        selectRepository = _selectRepository.asObserver()
        showRepository = _selectRepository.asObservable().map {$0.url}
        
        let _reload = PublishSubject<Void>()
        reload = _reload.asObserver()
        
        let _alertMessage = PublishSubject<String>()
        alertMessage = _alertMessage.asObservable()
        
        repositoies = Observable.combineLatest(_reload, _currentLanguage) { _, language in language }
            .flatMap {
                service.getMostPopularRepositories(byLanguage: $0)
                    .catchError { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }
            .asDriver(onErrorJustReturn: [])
        
        title = _currentLanguage.asObservable()
    }
}
