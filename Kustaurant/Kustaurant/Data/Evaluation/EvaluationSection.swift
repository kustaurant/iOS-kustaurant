//
//  EvaluationSection.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import Foundation

enum EvaluationSection: CaseIterable {
    case title
    case keyword
    case rating
    case review
    
    init?(index: Int) {
        switch index {
        case Self.title.index: self = .title
        case Self.keyword.index: self = .keyword
        case Self.rating.index: self = .rating
        case Self.review.index: self = .review
        default: return nil
        }
    }
    
    var index: Int {
        switch self {
        case .title: return 0
        case .keyword: return 1
        case .rating: return 2
        case .review: return 3
        }
    }
    
    static var count: Int {
        Self.allCases.count
    }
}
