//
//  Network.swift
//  Moya+Rx
//
//  Created by tanyadong on 2018/1/18.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SVProgressHUD
import Result
import RxSwiftExt
import RxOptional
import RxCocoa

struct NetWork {
    
    static private let provider = MoyaProvider<APIManager>(requestClosure:requestClosure,
                                                           plugins: [networkLoggerPlugin,
                                                                     networkActivityPlugin])

    static let disposeBag: DisposeBag = DisposeBag()
    
    static let indicator = ActivityIndicator()
    
    static func requestPM2_5(with city: String) -> Observable<[PM25]> {
        return request(with: .pm2_5(city), showHUD: true).map { (response) -> [PM25] in
            print("🐼🐼🐼🐼🐼🐼🐼🐼")
            if let t = response {
                return try t.mapObjects(PM25.self)
            }else {
                return []
            }
        }.catchErrorJustReturn([])
    }

    
    static func request(with target: APIManager,
                        showHUD: Bool = true,
                        retryMaxCount: Int = 2) -> Observable<Response?> {
        if showHUD {
            indicator.asDriver()
                .drive(SVProgressHUD.rx.isAnimating)
                .disposed(by: disposeBag)
        }
        
        return   provider.rx.request(target)
                .asObservable()
                .trackActivity(indicator,show: showHUD)
                .filterCustomErrorCode()
                .materialize()
                .map({ (event) -> Response? in
                    switch event{
                    case .next(let t):
                        return t
                    default:
                        return nil
                    }
                })
    }
}

extension ObservableType where E == Response {
    
    func showLoadingHUD(_ show: Bool = true) -> Observable<E> {
        guard show else { return self as! Observable<Response> }
        return self.do(onNext: { (_) in
            SVProgressHUD.dismiss(withDelay: 0.1)
        }, onError: { (_) in
            SVProgressHUD.showError(withStatus: "errror")
        }, onCompleted: {
            SVProgressHUD.dismiss(withDelay: 0.1)
        }, onSubscribe: {
            SVProgressHUD.show(withStatus: "loading")
        }) {
            SVProgressHUD.dismiss(withDelay: 0.1)
        }
    }
}

extension Reactive where Base: SVProgressHUD {
    
    public static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) {progressHUD, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
}
