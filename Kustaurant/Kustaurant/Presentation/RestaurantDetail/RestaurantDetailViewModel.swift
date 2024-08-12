//
//  RestaurantDetailViewModel.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation

extension RestaurantDetailViewModel {
    
    enum TabType {
        case menu, review
    }
}

final class RestaurantDetailViewModel {
    
    private(set) var sectionHeaders: [RestaurantDetailSection: RestaurantDetailHeaderItem] = [:]
    private(set) var sectionItems: [RestaurantDetailSection: [RestaurantDetailCellItem]] = [:]
    private(set) var tabType: TabType = .menu
}
