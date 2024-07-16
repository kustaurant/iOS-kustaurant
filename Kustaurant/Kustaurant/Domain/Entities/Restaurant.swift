//
//  Restaurant.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import Foundation

struct Restaurant: Codable {
    var restaurantId: Int?
    var restaurantName: String?
    var restaurantImgUrl: String?
    var mainTier: Int?
    var restaurantCuisine: String?
    var restaurantPosition: String?
    var restaurantAddress: String?
    var isOpen: Bool?
    var businessHours: String?
    var naverMapUrl: String?
    var situationList: [String?]?
    var partnershipInfo: String?
    var evaluationCount: Int?
    var restaurantScore: String?
    var isEvaluated: Bool?
    var isFavorite: Bool?
    var restaurantMenuList: [RestaurantMenu?]?
}

struct RestaurantMenu: Codable {
    var menuId: Int?
    var menuName: String?
    var menuPrice: String?
    var naverType: String?
    var menuImgUrl: String?
}
