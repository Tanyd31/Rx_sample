//
//  MovieViewActorsCell.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources
import ReusableKit

typealias ActorsSection = SectionModel<Void,ActorCellReactor>

class MovieViewActorsCell: BaseTableViewCell {

    fileprivate struct Reusable {
        static let actorCell = ReusableCell<ActorCollectionViewCell>()
    }
    
    fileprivate struct Metric {
        static let cellHeight = 177.f
        static let labelHorizontalMargin = 20.f
        static let collectionViewTop = 15.f
        static let collectionViewHeight = 150.f
        static let collectionViewItemSize = CGSize(width: 80, height: 150)
        static let minimumInteritemSpacing = 5.f
        static let sectionInset = UIEdgeInsetsMake(0, labelHorizontalMargin, 0, labelHorizontalMargin)
    }
    
    fileprivate struct Font {
        static let title = UIFont.systemFont(ofSize: 11)
    }
    
    fileprivate let titleLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = Font.title
        $0.text = "影人"
    }
    
    fileprivate let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = Metric.collectionViewItemSize
        $0.minimumInteritemSpacing = Metric.minimumInteritemSpacing
        $0.sectionInset = Metric.sectionInset
    }
    
    fileprivate lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.register(Reusable.actorCell)
    }
    
    fileprivate var dataSource: RxCollectionViewSectionedReloadDataSource<ActorsSection>!

    override func setupSubViews() {
        dataSource = MovieViewActorsCell.getDataSource()
        contentView.addSubViews(views: [titleLabel,collectionView])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.left = Metric.labelHorizontalMargin

        collectionView.top = titleLabel.bottom + Metric.collectionViewTop
        collectionView.left = contentView.left
        collectionView.width = contentView.width
        collectionView.height = Metric.collectionViewHeight
    }
    
    static func cellHeight() -> CGFloat {
        return Metric.cellHeight
    }
}

extension MovieViewActorsCell {
    static func getDataSource() -> RxCollectionViewSectionedReloadDataSource<ActorsSection> {
        return RxCollectionViewSectionedReloadDataSource<ActorsSection>.init(configureCell: { (ds, cv, ip, item) -> UICollectionViewCell in
            let cell = cv.dequeue(Reusable.actorCell, for: ip)
            cell.reactor = item
            return cell
        })
    }
}

extension MovieViewActorsCell: View {
    
    typealias Reactor = MovieViewActorsCellReactor
    
    func bind(reactor: MovieViewActorsCellReactor) {
        reactor.state.map { $0.sections }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}
