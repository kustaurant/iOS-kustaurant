//
//  Tier.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

enum Tier: Int, Codable {
    case unowned = -1
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
}

extension Tier {
    func backgroundColor() -> UIColor {
        switch self {
        case .first:
            return .tierFirst
        case .second:
            return .tierSecond
        case .third:
            return .tierThird
        case .fourth:
            return .tierFourth
        case .unowned:
            return .gray300
        }
    }
    
    var iconImageName: String {
        "icon_tier_\(String(describing: self))"
    }
    
    var zIndex: Int {
        switch self {
        case .first:
            return 4
        case .second:
            return 3
        case .third:
            return 2
        case .fourth:
            return 1
        case .unowned:
            return 0
        }
    }
}
