//
//  ActorCollectionViewCell.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import RxOptional

class ActorCollectionViewCell: UICollectionViewCell, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    typealias Reactor = ActorCellReactor
    
    fileprivate struct Metric {
        static let imageSize = CGSize(width: 80, height: 110)
        static let nameLabelTop = 5.f
        static let cellSize = CGSize(width: 80, height: 150)
        static let cellHorizontalMargin = 5.f
    }
    
    fileprivate let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    fileprivate let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 11)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        contentView.addSubViews(views: [imageView, nameLabel])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.sizeToFit()
        imageView.size = Metric.imageSize
        imageView.left = contentView.left
        
        nameLabel.sizeToFit()
        nameLabel.centerX = imageView.centerX
        nameLabel.top = imageView.bottom + Metric.nameLabelTop
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActorCollectionViewCell {
    func bind(reactor: ActorCellReactor) {
        reactor.state.map { $0.imageURL }
            .filterNil()
            .bind(to: imageView.rx.setWebImage(nil))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
