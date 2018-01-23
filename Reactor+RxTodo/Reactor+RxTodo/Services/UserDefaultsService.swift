//
//  UserDefaultsService.swift
//  Reactor+RxTodo
//
//  Created by tanyadong on 2018/1/23.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation

/// A generic key for `UserDefaults`. Extend this type to define custom user defaults keys.
///
/// ```
/// extension UserDefaultsKey {
///   static var myKey: Key<String> {
///     return "myKey"
///   }
///
///   static var anotherKey: Key<Int> {
///     return "anotherKey"
///   }
/// }
/// ```

struct UserDefaultsKey<T> {
    typealias Key<T> = UserDefaultsKey<T>
    let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(key: value)
    }
}

extension UserDefaultsKey {
    static var task: Key<[[String:Any]]> { return "task" }
}

protocol UserDefaultsServiceType {
    func value<T>(forKey key: UserDefaultsKey<T>) -> T?
    func set<T>(value: T?, forKey key: UserDefaultsKey<T>)
}

final class UserDefaultsService: UserDefaultsServiceType {
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    func value<T>(forKey key: UserDefaultsKey<T>) -> T? {
        return self.defaults.value(forKey: key.key) as? T
    }
    
    func set<T>(value: T?, forKey key: UserDefaultsKey<T>) {
        self.defaults.set(value, forKey: key.key)
        self.defaults.synchronize()
    }
    
}
