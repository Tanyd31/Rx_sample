//
//  StoryboardInitializable.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    static var identifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
   static func initialFromStoryboard(with storyboardName: String = "Main") -> Self {
        return UIStoryboard(name: storyboardName, bundle: .main).instantiateViewController(withIdentifier: Self.identifier) as! Self
    }
}
