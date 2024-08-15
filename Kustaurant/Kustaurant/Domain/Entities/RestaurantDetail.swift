//
//  RestaurantDetail.swift
//  Kustaurant
//
//  Created by 류연수 on 8/15/24.
//

import Foundation

struct RestaurantDetail: Decodable {
    let restaurantID: Int
    let restaurantImageURLString: String?
    
    let mainTier: Tier?
    let restaurantCuisine: String?
    
    let restaurantCuisineImageURLString: String?
    
    let restaurantPosition: String?
    let restaurantName: String?
    let restaurantAddress: String?
    let isOpen: Bool?
    let businessHours: String?
    let naverMapURLString: String?
    let situationList: [String]?
    let partnershipInfo: String?
    let evaluationCount: Int?
    let restaurantScore: Double?
    let isEvaluated: Bool?
    let isFavorite: Bool?
    let favoriteCount: Int?
    let restaurantMenuList: [RestaurantMenu]?
    
    enum CodingKeys: String, CodingKey {
        case restaurantID = "restaurantId"
        case restaurantImageURLString = "restaurantImgUrl"
        case mainTier, restaurantCuisine
        case restaurantCuisineImageURLString = "restaurantCuisineImgUrl"
        case restaurantPosition, restaurantName, restaurantAddress, isOpen, businessHours
        case naverMapURLString = "naverMapUrl"
        case situationList, partnershipInfo, evaluationCount, restaurantScore, isEvaluated, isFavorite, favoriteCount, restaurantMenuList
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantID = try container.decode(Int.self, forKey: .restaurantID)
        restaurantImageURLString = try? container.decodeIfPresent(String.self, forKey: .restaurantImageURLString)
        
        mainTier = try? container.decodeIfPresent(Tier.self, forKey: .mainTier)
        restaurantCuisine = try? container.decodeIfPresent(String.self, forKey: .restaurantCuisine)
        
        restaurantCuisineImageURLString = try? container.decodeIfPresent(String.self, forKey: .restaurantCuisineImageURLString)
        
        restaurantPosition = try? container.decodeIfPresent(String.self, forKey: .restaurantPosition)
        restaurantName = try? container.decodeIfPresent(String.self, forKey: .restaurantName)
        restaurantAddress = try? container.decodeIfPresent(String.self, forKey: .restaurantAddress)
        isOpen = try? container.decodeIfPresent(Bool.self, forKey: .isOpen)
        businessHours = try? container.decodeIfPresent(String.self, forKey: .businessHours)

        naverMapURLString = try? container.decodeIfPresent(String.self, forKey: .naverMapURLString)
        
        situationList = try? container.decodeIfPresent([String].self, forKey: .situationList)
        partnershipInfo = try? container.decodeIfPresent(String.self, forKey: .partnershipInfo)
        evaluationCount = try? container.decodeIfPresent(Int.self, forKey: .evaluationCount)
        restaurantScore = try? container.decodeIfPresent(Double.self, forKey: .restaurantScore)
        isEvaluated = try? container.decodeIfPresent(Bool.self, forKey: .isEvaluated)
        isFavorite = try? container.decodeIfPresent(Bool.self, forKey: .isFavorite)
        favoriteCount = try? container.decodeIfPresent(Int.self, forKey: .favoriteCount)
        restaurantMenuList = try? container.decodeIfPresent([RestaurantMenu].self, forKey: .restaurantMenuList)
    }
}
