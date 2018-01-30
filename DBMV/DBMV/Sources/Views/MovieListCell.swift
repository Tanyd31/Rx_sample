//
//  MovieListCell.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import ReactorKit
import Cosmos

class MovieListCell: BaseTableViewCell {
    
    fileprivate struct Metric {
        static let movieImageLeft = 15.f
        static let movieImageSize = CGSize(width: 80, height: 112)
        
        static let movieTitleLabelLeftRight = 15.f
        static let movieTitleLabelTop = 5.f
        
        static let starViewTop = 5.f
        static let starSize = CGSize(width: 140, height: 20)
        static let contentLabelTop = 5.f
        
        static let cellHeight = 155.f
    }
    
    fileprivate let movieImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    fileprivate let movieTitleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 2
    }
    
    fileprivate let starView = CosmosView().then {
        $0.settings.updateOnTouch = false
        $0.settings.fillMode = .half
        $0.settings.starMargin = 1.5
    }
    
    fileprivate let contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.numberOfLines = 0
    }
        
    override func setupSubViews() {
        contentView.addSubViews(views: [movieImageView,
                                        movieTitleLabel,
                                        starView,
                                        contentLabel])
    }
    
    override func updateConstraints() {
        movieImageView.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.movieImageLeft)
            make.size.equalTo(Metric.movieImageSize)
            make.centerY.equalToSuperview()
        }
        
        movieTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(movieImageView).offset(Metric.movieTitleLabelTop)
            make.left.equalTo(movieImageView.snp.right).offset(Metric.movieTitleLabelLeftRight)
            make.right.equalToSuperview().offset(-Metric.movieTitleLabelLeftRight)
        }
        
        starView.snp.makeConstraints { (make) in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(Metric.starViewTop)
            make.left.equalTo(movieTitleLabel)
            make.size.equalTo(Metric.starSize)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(Metric.contentLabelTop)
            make.left.right.equalTo(movieTitleLabel)
        }
        super.updateConstraints()
    }
    
    static func cellHeight() -> CGFloat {
        return Metric.cellHeight
    }
 
}


extension MovieListCell: View {
    
    typealias Reactor = MovieListCellReactor
    
    func bind(reactor: MovieListCellReactor) {
        reactor.state.map { $0.imageUrl }
            .bind(to: movieImageView.rx.setWebImage(nil))
            .disposed(by: disposeBag)
    
        reactor.state.map { $0.title }
            .bind(to: movieTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.ratingDouble }
            .bind(to: starView.rx.rating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.ratingStr }
            .bind(to: starView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.content }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
