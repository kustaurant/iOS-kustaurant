//
//  RestaurantDetail.swift
//  Kustaurant
//
//  Created by 류연수 on 8/21/24.
//

import Foundation

// TODO:- 나중에 actor로 바꿀 방법 고안 필요
struct RestaurantDetail {
    
    typealias Items = [RestaurantDetailSection: [RestaurantDetailCellItem]]
    typealias TabItems = [RestaurantDetailTabType: [RestaurantDetailCellItem]]
    
    private(set) var restaurantImageURLString: String
    private(set) var items: Items
    private(set) var tabType: RestaurantDetailTabType
    private(set) var tabItems: TabItems
    
    mutating func updateRestaurantImageURLString(as newValue: String) async {
        restaurantImageURLString = newValue
    }
    
    mutating func updateItems(as newValue: Items) async {
        items = newValue
        if newValue[.tab] is [RestaurantDetailMenu] {
            tabItems[.menu] = newValue[.tab]
        } else {
            tabItems[.review] = newValue[.tab]
        }
    }
    
    mutating func updateTabType(as newValue: RestaurantDetailTabType) async {
        tabType = newValue
        items[.tab] = tabItems[tabType]
    }
    
    mutating func updateTabItems(as newValue: TabItems) async {
        tabItems = newValue
        items[.tab] = tabItems[tabType]
    }
    
    init(restaurantImageURLString: String, items: Items, tabType: RestaurantDetailTabType = .menu, tabItems: TabItems) {
        self.restaurantImageURLString = restaurantImageURLString
        self.items = items
        self.tabType = tabType
        self.tabItems = tabItems
    }
}
