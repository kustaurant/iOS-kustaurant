//
//  Restaurant.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import Foundation

struct Restaurant: Codable, Identifiable {
    var restaurantId: Int?
    var restaurantRanking: Int?
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
    var restaurantScore: CGFloat?
    var isEvaluated: Bool?
    var isFavorite: Bool?
    var x: String?
    var y: String?
    var restaurantMenuList: [RestaurantMenu?]?
    
    var index: Int?
    
    enum CodingKeys: CodingKey {
        case restaurantId, restaurantRanking, restaurantName, restaurantImgUrl, mainTier, restaurantCuisine, restaurantPosition, restaurantAddress, isOpen, businessHours, naverMapUrl, situationList, partnershipInfo, evaluationCount, restaurantScore, isEvaluated, isFavorite, x, y, restaurantMenuList
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantId = try? container.decodeIfPresent(Int.self, forKey: .restaurantId)
        restaurantRanking = try? container.decodeIfPresent(Int.self, forKey: .restaurantRanking)
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
        restaurantScore = try? container.decodeIfPresent(CGFloat.self, forKey: .restaurantScore)
        isEvaluated = try? container.decodeIfPresent(Bool.self, forKey: .isEvaluated)
        isFavorite = try? container.decodeIfPresent(Bool.self, forKey: .isFavorite)
        x = try? container.decodeIfPresent(String.self, forKey: .x)
        y = try? container.decodeIfPresent(String.self, forKey: .y)
        restaurantMenuList = try? container.decodeIfPresent([RestaurantMenu].self, forKey: .restaurantMenuList)
    }
    
    var id: Int? {
        restaurantId
    }
}

struct RestaurantMenu: Codable {
    var menuId: Int?
    var menuName: String?
    var menuPrice: String?
    var naverType: String?
    var menuImgUrl: String?
}
