//
//  ViewController.swift
//  Moya+Rx
//
//  Created by tanyadong on 2018/1/18.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import SVProgressHUD
// 有问题！

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var button1: UIButton!
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    
    enum CustomError: Error {
        case myCustom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
//        retry2()
        textView.rx.text.orEmpty
            .map { $0.count > 0 }
            .bind(to: button1.rx.isEnabled)
            .disposed(by: disposeBag)
       
        // test
        button1.rx.tap
            .throttle(0.3, scheduler: MainScheduler.instance)
            .withLatestFrom(textView.rx.text.orEmpty)
            .flatMap { NetWork.requestPM2_5(with: $0) }
            .debug()
            .subscribe(onNext: { (data) in
                print(data)
                print("🐼")
            }, onError: { _ in
                print("onError")
            },onCompleted: {
                print("onCompleted")
            },onDisposed: {
                print("onDisposed")
            }).disposed(by: disposeBag)
        
        
        Observable.of(1,2,3,4,5)
            .map { value -> Int in
                if value > 4 {
                    throw MyError.notPositive(value: value)
                }
                return value
            }
            .materialize()
            .subscribe(onNext: { (result) in
                print(result)
            }, onError: { (error) in
                print("error")
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    
    /// 自定义的错误
    ///
    /// - notPositive: 不是正数
    /// - oversize: 数字过大
    enum MyError: Swift.Error, LocalizedError {
        case notPositive(value: Int)
        case oversize(value: Int)
        
        var errorDescription: String? {
            switch self {
            case let .notPositive(value):
                return "\(value)不是正数"
            case let .oversize(value):
                return "\(value)过大"
            }
        }
    }
   
    func retry2() {
        Observable<Int>
            .deferred { () -> Observable<Int> in
                return Observable.just(-1)
            }
            .map { value -> Int in
                if value <= 0 {
                    throw MyError.notPositive(value: value)
                } else if value > 100 {
                    throw MyError.oversize(value: value)
                } else {
                    return value
                }
            }.catchError { (error) -> Observable<Int> in
                return self.showAlert(error: error).retry()
            }.subscribe(onNext: { (_) in
                print("onNext🐻")
                
            }, onError: { (error) in
                print("onError🐻")
                
            }, onCompleted: {
                print("onCompleted🐻")
            }) {
                
            }.disposed(by: disposeBag)
    }
 
    
    func retry1() {
        Observable<Int>
            .deferred { () -> Observable<Int> in
                return Observable.just(-1)
            }
            .map { value -> Int in
                if value <= 0 {
                    throw MyError.notPositive(value: value)
                } else if value > 100 {
                    throw MyError.oversize(value: value)
                } else {
                    return value
                }
            }.retryWhen {  (errorObservable: Observable<MyError>) -> Observable<()> in
                errorObservable
                    .flatMap { error -> Observable<()> in
                        switch error {
                        case .notPositive(_):
                            return self.showAlert(error: error).map{ isEnsure in
                                if isEnsure > 0 {
                                    return ()
                                } else {
                                    throw error
                                }
                            }
                        case .oversize:
                            return Observable.error(error)
                        }
                }
            }.subscribe(onNext: { (_) in
                print("onNext🐻")

            }, onError: { (error) in
                print("onError🐻")

            }, onCompleted: {
                print("onCompleted🐻")
            }) {
                
        }.disposed(by: disposeBag)
    }
    
    func showAlert(error: Error) -> Observable<Int>{
        return Observable.create { [unowned self] observer in
            let alert = UIAlertController(title: "遇到了一个错误，重试还是使用默认值 1 替换？", message: "错误信息：\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "重试", style: .cancel, handler: { _ in
                observer.on(.error(error))
            }))
            
            alert.addAction(UIAlertAction(title: "替换", style: .default, handler: { _ in
                observer.on(.next(1))
                observer.on(.completed)
            }))
            self.present(alert, animated: true, completion: nil)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension ObservableType {
    
    public func retryWithBinaryExponentialBackoff(maxAttemptCount: Int, interval: TimeInterval) -> Observable<Self.E> {
        return self.asObservable()
            .retryWhen { (errorObservable: Observable<Swift.Error>) -> Observable<()> in
                errorObservable
                    .scan((currentCount: 0, error: Optional<Swift.Error>.none), accumulator: { a, error in
                        return (currentCount: a.currentCount + 1, error: error)
                    })
                    .flatMap({ (currentCount, error) -> Observable<()> in
                        return ((currentCount > maxAttemptCount) ? Observable.error(error!) : Observable.just(()))
                            .delay(pow(2, Double(currentCount)) * interval, scheduler: MainScheduler.instance)
                    })
        }
    }
    
}

extension SVProgressHUD {
    static var rx_mbprogresshud_animating: AnyObserver<Bool> {
        
        return AnyObserver { event in
            
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                if value {
                    SVProgressHUD.show()
//                    let loadingNotification = MBProgressHUD.showAdded(to: (UIApplication.shared.keyWindow?.subviews.last)!, animated: true)
//                    loadingNotification.mode = self.mode
//                    loadingNotification.label.text = self.label.text
                } else {
                    SVProgressHUD.dismiss()
//                    MBProgressHUD.hide(for: (UIApplication.shared.keyWindow?.subviews.last)!, animated: true)
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                print(error)
            case .completed:
                break
            }
        }
    }
}


