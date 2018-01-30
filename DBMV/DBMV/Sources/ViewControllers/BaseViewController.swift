//
//  BaseViewController.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    lazy private (set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private (set) var didUpdateConstraints: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            setupConstraints()
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func setupUI() {
        
    }
    
    func setupConstraints() {
        
    }
    
    deinit {
        log.verbose("DEINIT: \(className)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
