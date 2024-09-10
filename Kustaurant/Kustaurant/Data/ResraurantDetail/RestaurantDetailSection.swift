//
//  RestaurantDetailSection.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation

protocol RestaurantDetailCellItem { }

enum RestaurantDetailSection: CaseIterable {
    case title
    case tier
    case affiliate
    case rating
    case tab
    
    init?(index: Int) {
        switch index {
        case Self.title.index: self = .title
        case Self.tier.index: self = .tier
        case Self.affiliate.index: self = .affiliate
        case Self.rating.index: self = .rating
        case Self.tab.index: self = .tab
        default: return nil
        }
    }
    
    var index: Int {
        switch self {
        case .title: return 0
        case .tier: return 1
        case .affiliate: return 2
        case .rating: return 3
        case .tab: return 4
        }
    }
    
    static var count: Int {
        Self.allCases.count
    }
}
