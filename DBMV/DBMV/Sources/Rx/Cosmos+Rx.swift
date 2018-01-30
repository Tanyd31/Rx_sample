
//
//  Cosmos+Rx.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import Cosmos
import RxCocoa
import RxSwift

extension Reactive where Base: CosmosView {
    var rating: Binder<Double> {
        return Binder(base) { view, rating in
            view.rating = Double(rating / 2.0)
        }
    }
    
    var text: Binder<String> {
        return Binder(base) { view, rating in
            view.text = rating
        }
    }
}
