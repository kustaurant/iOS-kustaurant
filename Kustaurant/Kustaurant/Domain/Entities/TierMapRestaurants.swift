//
//  TierMapRestaurants.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import Foundation

extension TierMapRestaurants {
    struct NonTieredRestaurants: Codable {
        var zoom: Int?
        var restaurants: [Restaurant?]?
    }
}

struct TierMapRestaurants: Codable {
    var minZoom: Int?
    var favoriteRestaurants: [Restaurant?]?
    var tieredRestaurants: [Restaurant?]?
    var nonTieredRestaurants: [NonTieredRestaurants?]?
    var solidPolygonCoordsList: [[Coords?]?]?
    var dashedPolygonCoordsList: [[Coords?]?]?
    var visibleBounds: [CGFloat?]?
}

