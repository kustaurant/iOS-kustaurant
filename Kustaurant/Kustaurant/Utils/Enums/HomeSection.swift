//
//  HomeSection.swift
//  Kustaurant
//
//  Created by 송우진 on 8/4/24.
//

import Foundation

enum HomeSection: Int, CaseIterable {
    case banner = 0
    case categories = 1
    case topRestaurants = 2
    case forMeRestaurants = 3
    
    func titleText() -> String? {
        switch self {
        case .categories:
            return "맛집 탐색 카테고리"
        case .topRestaurants:
            return "인증된 건대 TOP 맛집"
        case .forMeRestaurants:
            return "나를 위한 건대 맛집"
        default: return nil
        }
    }
    
    func subTitleText() -> String? {
        switch self {
        case .topRestaurants:
            return "가장 높은 평가를 받은 맛집을 알려드립니다."
        case .forMeRestaurants:
            return "즐겨찾기를 바탕으로 다른 맛집을 추천해 드립니다."
        default: return nil
        }
    }
}
