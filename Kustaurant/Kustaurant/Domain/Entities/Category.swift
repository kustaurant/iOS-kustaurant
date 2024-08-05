//
//  Category.swift
//  Kustaurant
//
//  Created by 송우진 on 7/25/24.
//

import Foundation

struct Category: Equatable {
    static let Height: CGFloat = 32
    var displayName: String
    var code: String
    var isSelect: Bool
    var origin: Origin
    var type: CategoryType
    
    enum Origin: Equatable {
        case cuisine(Cuisine)
        case situation(Situation)
        case location(Location)
    }
}

extension Category.Origin {
    func value() -> Any {
        switch self {
        case .cuisine(let value): return value
        case .situation(let value): return value
        case .location(let value): return value
        }
    }
}
