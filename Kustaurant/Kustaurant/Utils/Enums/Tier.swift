//
//  Tier.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

enum Tier: Int, Codable {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
    
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
        }
    }
}
