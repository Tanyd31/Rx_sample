//
//  MovieViewController.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import MJRefresh
import ReusableKit
import RxDataSources
import ReactorKit

final class MovieViewController: BaseViewController, View {
    
    typealias Reactor = MovieViewReactor
    
    fileprivate struct Resuable {
        static let imageCell = ReusableCell<MovieViewImageCell>()
        static let titleCell = ReusableCell<MovieViewTitleCell>()
        static let summaryCell = ReusableCell<MovieViewSummaryCell>()
        static let actorsCell = ReusableCell<MovieViewActorsCell>()
    }
    
    fileprivate let tableView = UITableView().then {
        $0.estimatedRowHeight = 0
        $0.separatorStyle = .none
        $0.mj_header = MJRefreshNormalHeader()
        $0.tableFooterView = UIView()
        $0.register(Resuable.imageCell)
        $0.register(Resuable.titleCell)
        $0.register(Resuable.summaryCell)
        $0.register(Resuable.actorsCell)
    }
    
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<MovieViewSection>
    
    init(reactor: MovieViewReactor) {
        defer { self.reactor = reactor }
        dataSource = MovieViewController.getDataSource()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension MovieViewController {
    
    func bind(reactor: MovieViewReactor) {
        
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
        
        // State
        reactor.state.map { $0.title }
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .bind(to: tableView.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}


extension MovieViewController {
    static func getDataSource() -> RxTableViewSectionedReloadDataSource<MovieViewSection> {
        return RxTableViewSectionedReloadDataSource<MovieViewSection>.init(configureCell: { (ds, tb, ip, item) -> UITableViewCell in
            switch item{
            case let .image(reactor):
                let cell = tb.dequeue(Resuable.imageCell, for: ip)
                cell.reactor = reactor
                return cell
            case let .title(reactor):
                let cell = tb.dequeue(Resuable.titleCell, for: ip)
                cell.reactor = reactor
                return cell
            case let .summary(reactor):
                let cell = tb.dequeue(Resuable.summaryCell, for: ip)
                cell.reactor = reactor
                return cell
            case let .actors(reactor):
                let cell = tb.dequeue(Resuable.actorsCell, for: ip)
                cell.reactor = reactor
                return cell
            }
        })
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = dataSource[indexPath]
        switch sectionItem {
        case .image:
            return Resuable.imageCell.class.cellHeight()
        case let .title(item):
            return Resuable.titleCell.class.cellHeight(reactor: item)
        case let .summary(item):
            return Resuable.summaryCell.class.cellHeight(reactor: item)
        case .actors:
            return Resuable.actorsCell.class.cellHeight()
        }
    }
}
