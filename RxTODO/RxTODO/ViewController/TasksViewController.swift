//
//  TasksViewController.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class TasksViewController: UIViewController, StoryboardInitializable, BindableType {
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    
    var viewModel: TaskViewModel!
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<TaskSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        tableView.rowHeight = 70
    }
    
    func bindViewModel() {
        addButton.rx.tap
            .bind(to: viewModel.add)
            .disposed(by: rx.disposeBag)
        
        dataSource = RxTableViewSectionedAnimatedDataSource<TaskSection>(configureCell: {
            [weak self] (ds, tb, ip, item) -> UITableViewCell in
                let cell = tb.dequeueReusableCell(withClass: TaskCell.self, for: ip)
                if let `self` = self {
                    cell.config(with: item, toggle: self.viewModel.toggle)
                }
                return cell
            }, titleForHeaderInSection: { (ds, section) -> String? in
                return ds.sectionModels[section].model
        })
        
        viewModel.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(TaskItem.self)
            .bind(to: viewModel.selectTask)
            .disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

