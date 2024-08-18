//
//  TierBaseViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 8/18/24.
//

import Foundation

protocol TierBaseViewModel {
    var categories: [Category] { get }
    var filteredCategories: [Category] { get }
}

extension TierBaseViewModel {
    var filteredCategories: [Category] {
        if categories.allSatisfy({ $0.displayName == "전체" }) && !categories.isEmpty {
            return [categories.first!]
        }
        return categories.filter { $0.displayName != "전체" }
    }
}
