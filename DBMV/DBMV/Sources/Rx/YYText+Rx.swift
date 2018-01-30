//
//  YYText+Rx.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/30.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import YYText

extension Reactive where Base: YYLabel {
    var attributedText: Binder<NSAttributedString> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }
}
