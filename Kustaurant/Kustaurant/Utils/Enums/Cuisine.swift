//
//  Cuisine.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

/// 음식 종류
enum Cuisine: String, CaseIterable {
    case all = "전체"
    case ko = "한식"
    case ja = "일식"
    case ch = "중식"
    case we = "양식"
    case `as` = "아시안"
    case me = "고기"
    case ck = "치킨"
    case se = "해산물"
    case hp = "햄버거/피자"
    case bs = "분식"
    case pu = "술집"
    case ca = "카페/디저트"
    case ba = "베이커리"
    case sa = "샐러드"
    case jh = "제휴업체"
    
    var category: Category {
        Category(displayName: rawValue, code: String(describing: self).uppercased(), isSelect: false, origin: .cuisine(self), type: .cuisine)
    }
    
    var iconName: String {
        "icon_cuisine_\(String(describing: self))"
    }
}
