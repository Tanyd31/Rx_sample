//
//  MovieViewSection.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation
import RxDataSources

enum MovieViewSectionItem {
    case image(MovieViewImageCellReactor)
    case title(MovieViewTitleCellReactor)
    case summary(MovieViewSummaryCellReactor)
    case actors(MovieViewActorsCellReactor)
}

enum MovieViewSection {
    case content([MovieViewSectionItem])
}

extension MovieViewSection: SectionModelType {
    var items: [MovieViewSectionItem] {
        switch self {
        case let .content(items):
            return items
        }
    }
    
    init(original: MovieViewSection, items: [MovieViewSectionItem]) {
        switch original {
        case .content:
            self = .content(items)
        }
    }
    
}
