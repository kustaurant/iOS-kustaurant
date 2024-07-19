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
    var mainTier: Tier?
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
    
    enum CodingKeys: CodingKey {
        case restaurantId, restaurantName, restaurantImgUrl, mainTier, restaurantCuisine, restaurantPosition, restaurantAddress, isOpen, businessHours, naverMapUrl, situationList, partnershipInfo, evaluationCount, restaurantScore, isEvaluated, isFavorite, restaurantMenuList
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantId = try? container.decodeIfPresent(Int.self, forKey: .restaurantId)
        restaurantName = try? container.decodeIfPresent(String.self, forKey: .restaurantName)
        restaurantImgUrl = try? container.decodeIfPresent(String.self, forKey: .restaurantImgUrl)
        mainTier = try? container.decodeIfPresent(Tier.self, forKey: .mainTier)
        restaurantCuisine = try? container.decodeIfPresent(String.self, forKey: .restaurantCuisine)
        restaurantPosition = try? container.decodeIfPresent(String.self, forKey: .restaurantPosition)
        restaurantAddress = try? container.decodeIfPresent(String.self, forKey: .restaurantAddress)
        isOpen = try? container.decodeIfPresent(Bool.self, forKey: .isOpen)
        businessHours = try? container.decodeIfPresent(String.self, forKey: .businessHours)
        naverMapUrl = try? container.decodeIfPresent(String.self, forKey: .naverMapUrl)
        situationList = try? container.decodeIfPresent([String].self, forKey: .situationList)
        partnershipInfo = try? container.decodeIfPresent(String.self, forKey: .partnershipInfo)
        evaluationCount = try? container.decodeIfPresent(Int.self, forKey: .evaluationCount)
        restaurantScore = try? container.decodeIfPresent(String.self, forKey: .restaurantScore)
        isEvaluated = try? container.decodeIfPresent(Bool.self, forKey: .isEvaluated)
        isFavorite = try? container.decodeIfPresent(Bool.self, forKey: .isFavorite)
        restaurantMenuList = try? container.decodeIfPresent([RestaurantMenu].self, forKey: .isFavorite)
    }
}

struct RestaurantMenu: Codable {
    var menuId: Int?
    var menuName: String?
    var menuPrice: String?
    var naverType: String?
    var menuImgUrl: String?
}
