//
//  HomeRestaurantLists.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import Foundation

struct HomeRestaurantLists: Codable {
    var topRestaurantsByRating: [Restaurant?]?
    var restaurantsForMe: [Restaurant?]?
}
