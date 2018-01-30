//
//  MovieViewTitleCell.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import Cosmos
import ManualLayout
import ReactorKit

class MovieViewTitleCell: BaseTableViewCell {

    fileprivate struct Metric {
        static let titleLabelTopLeft = 20.f
        static let titleLabelWidth = 237.f
        static let contentLabelTop = 8.f
        static let contentLabelRight = 8.f
        static let ratingViewTopRight = 20.f
        static let ratingViewSize = CGSize(width: 85, height: 85)
        static let ratingLabelTop = 9.f
        static let ratingValueLabelTop = 3.f
        static let starViewTop = 3.f
        static let starViewSize = CGSize(width: 60, height: 15)
        static let ratingsCountLabelTop = 3.f
    }
    
    fileprivate struct Font {
        static let title = UIFont.boldSystemFont(ofSize: 17)
        static let content = UIFont.systemFont(ofSize: 11)
    }
    
    fileprivate let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.numberOfLines = 2
    }
    
    fileprivate let contentLabel = UILabel().then {
        $0.font = Font.content
        $0.textColor = .gray
        $0.numberOfLines = 0
    }

    fileprivate let ratingView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 4, height: 4)
        $0.layer.shadowColor = UIColor.black.cgColor
    }
    
    fileprivate let ratingLabel = UILabel().then {
        $0.font = Font.content
        $0.textColor = .lightGray
        $0.text = "豆瓣评分"
    }
    
    fileprivate let ratingValueLabel = UILabel().then {
        $0.font = Font.title
    }
    
    fileprivate let starView = CosmosView().then {
        $0.settings.updateOnTouch = false
        $0.settings.fillMode = .half
        $0.settings.starSize = 11
        $0.settings.starMargin = 1.5
    }
    
    fileprivate let ratingsCountLabel = UILabel().then {
        $0.font = Font.content
        $0.textColor = .gray
    }
    
    override func setupSubViews() {
        ratingView.addSubViews(views: [ratingLabel, ratingValueLabel, starView, ratingsCountLabel])
        contentView.addSubViews(views: [titleLabel, contentLabel, ratingView])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ratingView.top = Metric.ratingViewTopRight
        ratingView.size = Metric.ratingViewSize
        ratingView.right = contentView.right - Metric.ratingViewTopRight
        
        titleLabel.sizeToFit()
        titleLabel.left = Metric.titleLabelTopLeft
        titleLabel.top = Metric.titleLabelTopLeft

        contentLabel.sizeToFit()
        contentLabel.left = Metric.titleLabelTopLeft
        contentLabel.right2 = ratingView.left - Metric.contentLabelRight
        contentLabel.top = titleLabel.bottom + Metric.contentLabelTop

        ratingLabel.sizeToFit()
        ratingLabel.centerX = ratingView.width * 0.5
        ratingLabel.top = Metric.ratingLabelTop

        ratingValueLabel.sizeToFit()
        ratingValueLabel.centerX = ratingLabel.centerX
        ratingValueLabel.top = ratingLabel.bottom + Metric.ratingValueLabelTop

        starView.sizeToFit()
        starView.top = ratingValueLabel.bottom + Metric.starViewTop
        starView.centerX = ratingLabel.centerX
        starView.size = Metric.starViewSize
        
        ratingsCountLabel.sizeToFit()
        ratingsCountLabel.centerX = ratingLabel.centerX
        ratingsCountLabel.top = starView.bottom + Metric.ratingsCountLabelTop
    }
    
    
    static func cellHeight(reactor: MovieViewTitleCellReactor) -> CGFloat {
        var height: CGFloat = Metric.titleLabelTopLeft
        height += reactor.currentState.title.height(thatFitsWidth: Metric.titleLabelWidth, font: Font.title)
        height += Metric.contentLabelTop
        height += reactor.currentState.content.height(thatFitsWidth: Metric.titleLabelWidth, font: Font.content)
        height = max(height, Metric.ratingViewTopRight + Metric.ratingViewSize.height)
        height += Metric.titleLabelTopLeft
        return height
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MovieViewTitleCell: View {
    
    typealias Reactor = MovieViewTitleCellReactor
    
    func bind(reactor: MovieViewTitleCellReactor) {
        reactor.state.map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.content }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.ratingStr }
            .bind(to: ratingValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.ratingDouble }
            .bind(to: starView.rx.rating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.ratingsCount }
            .bind(to: ratingsCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
