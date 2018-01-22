//
//  ViewController.swift
//  GitHubSearch
//
//  Created by tanyadong on 2018/1/22.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SafariServices

class ViewController: UIViewController, StoryboardView {
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak private var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        searchController.isActive = true
        searchController.isActive = false
        UIView.setAnimationsEnabled(true)
    }
    
    func bind(reactor: GitHubSearchReactor) {
        
        searchController.searchBar.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset.map { [weak self] (offset) -> Bool in
                guard let `self` = self else { return false }
                guard self.tableView.contentSize.height > self.tableView.bounds.height else { return false }
                return offset.y + self.tableView.bounds.height >= self.tableView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.repos }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { indexPath, repo, cell in
            cell.textLabel?.text = repo
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self, weak reactor] indexPath in
            guard let `self` = self else { return }
            self.view.endEditing(true)
            self.tableView.deselectRow(at: indexPath, animated: false)
            guard let repo = reactor?.currentState.repos[indexPath.row] else { return }
            guard let url = URL(string: "https://github.com/\(repo)") else { return }
            let viewController = SFSafariViewController(url: url)
            self.searchController.present(viewController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

