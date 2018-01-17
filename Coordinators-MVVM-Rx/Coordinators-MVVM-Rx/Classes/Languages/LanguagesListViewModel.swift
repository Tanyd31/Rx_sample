//
//  LanguagesViewModel.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LanguagesListViewModel {

    //MARK: input
    
    // 选中某个语言
    let selectLanguage: AnyObserver<String>
    
    // 点击取消
    let cancel: AnyObserver<Void>
    
    //MARK: output
    let languages: Driver<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>
    
    init(_ service: GithubService = GithubService.share) {
        
        let _selectLanguage = PublishSubject<String>()
        selectLanguage = _selectLanguage.asObserver()
        didSelectLanguage = _selectLanguage.asObservable()
        
        let _cancel = PublishSubject<Void>()
        cancel = _cancel.asObserver()
        didCancel = _cancel.asObservable()
        languages = service.getLanguageList().asDriver(onErrorJustReturn: [])
    }
    
}
