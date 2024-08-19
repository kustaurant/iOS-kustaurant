//
//  TabBarPage.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import Foundation

enum TabBarPage: String {
    case home = "home"
    case draw = "draw"
    case tier = "tier"
    case community = "community"
    case mypage = "mypage"
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .draw
        case 2: self = .tier
        case 3: self = .community
        case 4: self = .mypage
        default: return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home: return "홈"
        case .draw: return "뽑기"
        case .tier: return "티어"
        case .community: return "커뮤니티"
        case .mypage: return "마이페이지"
        }
    }
    
    func pageImageName() -> String {
        "icon_tabbar_\(rawValue)"
    }
}
