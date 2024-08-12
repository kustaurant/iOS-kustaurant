//
//  RestaurantDetailTitle.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation

struct RestaurantDetailTitle: RestaurantDetailHeaderItem {
    
    let cuisineType: String
    let title: String
    let isReviewCompleted: Bool
    let address: String
    let openingHours: String
    let mapURL: URL?
}
