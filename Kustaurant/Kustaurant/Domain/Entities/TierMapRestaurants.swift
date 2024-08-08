//
//  TierMapRestaurants.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import Foundation

struct TierMapRestaurants: Codable {
    struct NonTieredRestaurants: Codable {
        var zoom: Int?
        var restaurants: [Restaurant?]?
    }
    
    struct Coords: Codable {
        var x: CGFloat?
        var y: CGFloat?
    }
    
    var minZoom: Int?
    var favoriteRestaurants: [Restaurant?]?
    var tieredRestaurants: [Restaurant?]?
    var nonTieredRestaurants: [NonTieredRestaurants]?
    var solidPolygonCoordsList: [Coords?]?
    var dashedPolygonCoordsList: [Coords?]?
    var visibleBounds: [Int?]?
}
