//
//  RestaurantDetailTierInfo.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation

struct RestaurantDetailTiers: RestaurantDetailCellItem {
    let tiers: [RestaurantDetailTierInfo]
}

struct RestaurantDetailTierInfo {
    
    let iconImageURLString: String
    let title: String
    let backgroundHexColor: String
}
