//
//  MovieListViewController.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import URLNavigator
import Then
import ReusableKit
import SnapKit
import RxDataSources
import RxViewController
import MJRefresh

typealias MovieListSection = SectionModel<Void,MovieListCellReactor>

final class MovieListViewController: BaseViewController, View {
    
    typealias Reactor = MovieListViewReactor
    
    fileprivate let tableView = UITableView().then {
        $0.estimatedRowHeight = 0
        $0.mj_header = MJRefreshNormalHeader()
        let footer = MJRefreshAutoNormalFooter()
        footer.stateLabel.text = ""
        $0.mj_footer = footer
        $0.tableFooterView = UIView()
        $0.register(Reusable.movieListCell)
    }
    
    fileprivate struct Reusable {
        static let movieListCell = ReusableCell<MovieListCell>()
    }
    
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<MovieListSection>
    
    init(reactor: MovieListViewReactor) {
        defer { self.reactor = reactor }
        dataSource = MovieListViewController.getDataSource()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        title = "TOP250"
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// Bind
extension MovieListViewController {
    func bind(reactor: MovieListViewReactor) {
        
        // Delegate
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // Action
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.mj_header.rx.event
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.mj_footer.rx.event
            .map { _ in Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MovieListCellReactor.self)
            .map (Reactor.Action.selectedItem)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing || $0.isLoading }
            .bind(to: tableView.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedID }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension MovieListViewController {
    static func getDataSource() -> RxTableViewSectionedReloadDataSource<MovieListSection> {
        return RxTableViewSectionedReloadDataSource<MovieListSection>(configureCell: { (ds, tb, ip, item) in
            let cell = tb.dequeue(Reusable.movieListCell, for: ip)
            cell.reactor = item
            return cell
        })
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Reusable.movieListCell.class.cellHeight()
    }
}
