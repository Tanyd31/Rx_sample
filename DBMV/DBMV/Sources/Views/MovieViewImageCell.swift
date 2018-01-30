//
//  MovieViewImageCell.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import ReactorKit
import Kingfisher

class MovieViewImageCell: BaseTableViewCell {

    fileprivate struct Metric {
        static let imageSize = CGSize(width: 200, height: 280)
        static let cellHeight = 390.f
    }
    
    fileprivate let movieImageView = UIImageView().then {
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowOffset = CGSize(width: 4, height: 4)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.contentMode = .scaleAspectFit
    }
    
    override func setupSubViews() {
        contentView.backgroundColor = UIColor.FlatUI.pumkin
        contentView.addSubview(movieImageView)
        setNeedsUpdateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.size = Metric.imageSize
        movieImageView.center = contentView.center
    }
    
    static func cellHeight() -> CGFloat {
        return Metric.cellHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MovieViewImageCell: ReactorKit.View {
   
    typealias Reactor = MovieViewImageCellReactor
    
    func bind(reactor: MovieViewImageCellReactor) {
        reactor.state.map { $0.imageURL }
            .bind(to: movieImageView.rx.setWebImage(nil))
            .disposed(by: disposeBag)
    }
    
}
