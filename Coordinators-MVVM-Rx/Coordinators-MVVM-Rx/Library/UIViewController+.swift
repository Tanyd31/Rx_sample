//
//  UIViewController+.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func fromStoryboard(of identifier: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: identifier, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}

