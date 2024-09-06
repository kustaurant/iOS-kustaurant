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
    
    mutating func addComment(to commentId: Int, newComment: RestaurantDetailReview) async {
        guard var currentTabItems = tabItems[.review] as? [RestaurantDetailReview] else {
            return
        }
        
        if let parentIndex = currentTabItems.firstIndex(where: { $0.commentId == commentId }) {
            let insertIndex = parentIndex + 1 + currentTabItems[parentIndex].commentChildrenCount
            let currentTabItem = currentTabItems[parentIndex]
            currentTabItems[parentIndex] = currentTabItem
            if insertIndex - 1 >= 0 {
                currentTabItems[insertIndex - 1].hasComments = true
                let tabItemBefore = currentTabItems[insertIndex-1]
                currentTabItems[insertIndex - 1] = tabItemBefore
            }
            currentTabItems.insert(newComment, at: insertIndex)
        }
        
        await updateTabItems(as: [.review: currentTabItems])
    }
    
    mutating func deleteComment(commentId: Int) async {
        guard
            var currentTabItems = tabItems[.review] as? [RestaurantDetailReview],
            let idx = currentTabItems.firstIndex (where: { $0.commentId == commentId })
        else { return }
        if let parentIndex = currentTabItems.firstIndex(where: { $0.commentId == commentId }) {
            currentTabItems[parentIndex].commentChildrenCount -= 1
            let currentTabItem = currentTabItems[parentIndex]
            currentTabItems[parentIndex] = currentTabItem
        }
        currentTabItems.remove(at: idx)
        await updateTabItems(as: [.review: currentTabItems])
    }
    
    mutating func likeOrDislikeComment(commentId: Int, likeStatus: CommentLikeStatus) async {
        guard
            var currentTabItems = tabItems[.review] as? [RestaurantDetailReview],
            let idx = currentTabItems.firstIndex (where: { $0.commentId == commentId })
        else { return }
        
        var item = currentTabItems[idx]
        item.updateLikeStatus(to: likeStatus)
        currentTabItems[idx] = item
        await updateTabItems(as: [.review: currentTabItems])
    }
    
    init(restaurantImageURLString: String, items: Items, tabType: RestaurantDetailTabType = .menu, tabItems: TabItems) {
        self.restaurantImageURLString = restaurantImageURLString
        self.items = items
        self.tabType = tabType
        self.tabItems = tabItems
    }
}
