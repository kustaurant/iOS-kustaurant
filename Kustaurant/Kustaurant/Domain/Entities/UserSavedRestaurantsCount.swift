//
//  UserSavedRestaurantsCount.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

struct UserSavedRestaurantsCount: Codable {
    let iconImgUrl: String?
    let nickname: String?
    let evaluationCount: Int?
    let favoriteCount: Int?
    
    static func empty() -> UserSavedRestaurantsCount {
        return UserSavedRestaurantsCount(iconImgUrl: nil, nickname: "", evaluationCount: 0, favoriteCount: 0)
    }
}
