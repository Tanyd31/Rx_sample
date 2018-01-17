//
//  TaskCell.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var toggleButton: UIButton!
    
    private (set) var disposeBag: DisposeBag = DisposeBag()
    
    func config(with task: TaskItem, toggle: AnyObserver<TaskItem>) {

        task.rx.observe(String.self, "title")
            .subscribe(onNext: { [weak self] title in
            self?.titleLabel.text = title
        }).disposed(by: disposeBag)
        
        task.rx.observe(Date.self, "checked")
            .subscribe(onNext: { [weak self] date in
            let image = UIImage(named: date == nil ? "ItemNotChecked" : "ItemChecked")
            self?.toggleButton.setImage(image, for: .normal)
        }).disposed(by: disposeBag)
        
        toggleButton.rx.tap
            .map { task }
            .bind(to: toggle)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}
