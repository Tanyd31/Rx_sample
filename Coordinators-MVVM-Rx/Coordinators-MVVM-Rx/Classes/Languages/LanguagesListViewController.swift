//
//  LanguagesViewController.swift
//  Coordinators-MVVM-Rx
//
//  Created by tanyadong on 2018/1/11.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LanguagesListViewController: UIViewController,StoryboardInitializable {
    
    @IBOutlet weak private var tableView: UITableView!
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    var viewModel: LanguagesListViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = chooseLanguageButton
    }
    
    private func binding() {
        
        viewModel.languages.drive(tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)) { _ ,language, cell in
            cell.textLabel?.text = language
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        chooseLanguageButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectLanguage)
            .disposed(by: disposeBag)
    }
}
