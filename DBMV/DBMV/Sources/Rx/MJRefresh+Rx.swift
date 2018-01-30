//
//  MJRefresh+Rx.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: MJRefreshComponent {
    var isRefresh: Binder<Bool> {
        return Binder(base) { view, refresh in
            if !refresh {
                view.endRefreshing()
            }
        }
    }
}

extension Reactive where Base: UITableView {
    var isRefreshing: Binder<Bool> {
        return Binder(base) { view, refresh in
            if let header = view.mj_header, header.isRefreshing {
                header.endRefreshing()
            }
            if let footer = view.mj_footer, footer.isRefreshing {
                footer.endRefreshing()
            }
        }
    }
}

// copy from RxTarget.Swift
class RxTarget : NSObject, Disposable {
    
    private var retainSelf: RxTarget?
    
    override init() {
        super.init()
        retainSelf = self
        
        #if TRACE_RESOURCES
            _ = Resources.incrementTotal()
        #endif
        
        #if DEBUG
            MainScheduler.ensureExecutingOnScheduler()
        #endif
    }
    
    func dispose() {
        #if DEBUG
            MainScheduler.ensureExecutingOnScheduler()
        #endif
        retainSelf = nil
    }
    
    #if TRACE_RESOURCES
    deinit {
    _ = Resources.decrementTotal()
    }
    #endif
}

// from ControlTarget.Swift
final class RefreshTarget<Component: MJRefreshComponent>: RxTarget {
    typealias Callback = MJRefreshComponentRefreshingBlock
    var callback: Callback?
    weak var component:Component?
    
    let selector = #selector(RefreshTarget.eventHandler)
    
    init(_ component: Component,callback:@escaping Callback) {
        self.callback = callback
        self.component = component
        super.init()
        component.setRefreshingTarget(self, refreshingAction: selector)
    }
    
    @objc func eventHandler() {
        if let callback = callback {
            callback()
        }
    }
    override func dispose() {
        super.dispose()
        component?.refreshingBlock = nil
        callback = nil
    }
}

// from UIControl+Rx.Swift
// public func controlEvent(_ controlEvents: UIControlEvents) -> ControlEvent<()>
extension Reactive where Base: MJRefreshComponent {
    var event: ControlEvent<Base> {
        let source: Observable<Base> = Observable.create { [weak control = base] observer  in
            MainScheduler.ensureExecutingOnScheduler()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }
            let observer = RefreshTarget(control) {
                observer.on(.next(control))
            }
            return observer
            }.takeUntil(deallocated)
            .share()
        return ControlEvent(events: source)
    }
}
