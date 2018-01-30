//
//  MovieViewSummaryCell.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import ReactorKit
import YYText

class MovieViewSummaryCell: BaseTableViewCell {

    fileprivate struct Metric {
        static let labelHorizontalMargin = 20.f
        static let contentLabelBottomTop = 25.f
        static let contentLabelWidth = UIScreen.main.bounds.width - 2 * labelHorizontalMargin
        static let contentLabelHeight = 100.f
    }
    
    fileprivate struct Font {
        static let title = UIFont.systemFont(ofSize: 11)
        static let content = UIFont.systemFont(ofSize: 13)
    }
    
    fileprivate let titleLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = Font.title
        $0.text = "剧情介绍"
    }
    
    fileprivate let contentLabel = YYLabel().then {
        $0.isUserInteractionEnabled = true
        $0.numberOfLines = 0
        $0.textVerticalAlignment = .top
        $0.textColor = .black
        $0.font = Font.content
    }

    override func setupSubViews() {
        addSeeMoreButton()
        contentView.addSubViews(views: [titleLabel, contentLabel])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.left = Metric.labelHorizontalMargin
        
        contentLabel.frame = CGRect(x: Metric.labelHorizontalMargin,
                                    y: Metric.contentLabelBottomTop,
                                    width: Metric.contentLabelWidth,
                                    height: Metric.contentLabelHeight)
    }
    
    fileprivate func addSeeMoreButton() {
        let text = NSMutableAttributedString(string: "...more")
        let highlight = YYTextHighlight()
        highlight.tapAction = { [weak self]_,_,_,_ in
            guard let `self` = self else { return }
            self.contentLabel.sizeToFit()
        }
        
        text.yy_setTextHighlight(highlight, range: NSRange(location: 3, length: 4))
        text.yy_setColor(UIColor.seeMore, range: NSRange(location: 3, length: 4))
        text.yy_font = contentLabel.font
        
        let seeMoreLabel = YYLabel()
        seeMoreLabel.attributedText = text
        seeMoreLabel.sizeToFit()
        
        let truncationToken = NSAttributedString.yy_attachmentString(withContent: seeMoreLabel,
                                                                     contentMode: .center,
                                                                     attachmentSize: seeMoreLabel.bounds.size,
                                                                     alignTo: text.yy_font!,
                                                                     alignment: .center)
        contentLabel.truncationToken = truncationToken
    }
    
    static func cellHeight(reactor: MovieViewSummaryCellReactor) -> CGFloat {
        var height: CGFloat = 0
        height += Metric.contentLabelBottomTop * 2.0
        let summaryH = YYTextLayout(containerSize: CGSize(width: Metric.contentLabelWidth,
                                                          height: CGFloat.greatestFiniteMagnitude),
                                    text: reactor.currentState.summary)?.textBoundingSize.height ?? 0.0
        height += summaryH
        return height
    }

}

extension MovieViewSummaryCell: View {
    
    typealias Reactor = MovieViewSummaryCellReactor
    
    func bind(reactor: MovieViewSummaryCellReactor) {
        reactor.state.map { $0.summary }
            .bind(to: contentLabel.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
}
