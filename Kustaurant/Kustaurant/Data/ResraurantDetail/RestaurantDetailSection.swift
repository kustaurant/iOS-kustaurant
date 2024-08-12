//
//  RestaurantDetailSection.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation

protocol RestaurantDetailHeaderItem { }

protocol RestaurantDetailCellItem { }

enum RestaurantDetailSection: CaseIterable {
    case title
    case tier
    case affiliate
    case rating
    case tab
    
    static var count: Int {
        Self.allCases.count
    }
}
