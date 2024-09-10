//
//  FavoriteRestaurant.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

struct FavoriteRestaurant: Codable {
    let restaurantName: String?
    let restaurantImgURL: String?
    let mainTier: Tier?
    let restaurantType: String?
    let restaurantId: Int?
    let restaurantPosition: String?
}
