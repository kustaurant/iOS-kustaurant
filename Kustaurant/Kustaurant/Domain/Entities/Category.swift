//
//  Category.swift
//  Kustaurant
//
//  Created by 송우진 on 7/25/24.
//

import Foundation

struct Category: Equatable {
    static let height: CGFloat = 32
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

extension Category {
    static func extractCuisines(from categories: [Category]) -> [Cuisine] {
        categories.compactMap {
            if case let .cuisine(cuisine) = $0.origin {
                return cuisine
            }
            return nil
        }
    }
    
    static func extractSituations(from categories: [Category]) -> [Situation] {
        categories.compactMap {
            if case let .situation(situation) = $0.origin {
                return situation
            }
            return nil
        }
    }
    
    static func extractLocations(from categories: [Category]) -> [Location] {
        categories.compactMap {
            if case let .location(location) = $0.origin {
                return location
            }
            return nil
        }
    }
}
