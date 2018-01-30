//
//  Kingfisher+Rx.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {
   
    var setWebImage: (_ placeholder: UIImage?) -> Binder<URL> {
        return { placeholder in
            return Binder(self.base) { imageView, url in
                if let img = placeholder {
                    imageView.kf.setImage(with: url, placeholder: img)
                }else {
                    imageView.kf.setImage(with: url)
                }
            }
        }
    }
}

