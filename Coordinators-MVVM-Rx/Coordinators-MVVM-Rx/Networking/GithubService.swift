//
//  GitHubService.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
    case cannotParse
}

class GithubService {
    
    static let share: GithubService = GithubService()
    
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLanguageList() -> Observable<[String]> {
        return Observable.just([
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#"
            ])
    }
    
    func getMostPopularRepositories(byLanguage language: String) -> Observable<[Repository]> {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!
        return session.rx
            .json(url: url)
            .flatMap({ (json) -> Observable<[Repository]> in
                print(json)
                guard
                    let json = json as? [String: Any],
                    let itemsJSON = json["items"] as? [[String: Any]]
                    else { return Observable.error(ServiceError.cannotParse) }
                
                let repositories = itemsJSON.flatMap(Repository.init)
                return Observable.just(repositories)
        })
    }
}
