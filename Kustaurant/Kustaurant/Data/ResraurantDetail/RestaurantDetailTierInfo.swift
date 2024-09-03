//
//  RestaurantDetailTierInfo.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import UIKit

struct RestaurantDetailTiers: RestaurantDetailCellItem {
    let tiers: [RestaurantDetailTierInfo]
}

struct RestaurantDetailTierInfo {
    
    let restaurantCuisine: String?
    let title: String
    let backgroundColor: UIColor?
}
