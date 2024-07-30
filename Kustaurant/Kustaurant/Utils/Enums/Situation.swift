//
//  Situation.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

enum Situation: String, CaseIterable {
    case all = "전체"
    case one = "혼밥"
    case two = "2~4인"
    case three = "5인 이상"
    case four = "단체 회식"
    case five = "배달"
    case six = "야식"
    case seven = "친구 초대"
    case eight = "데이트"
    case nine = "소개팅"
    
    var category: Category {
        Category(displayName: rawValue, code: String(describing: self).uppercased(), isSelect: false)
    }
}
