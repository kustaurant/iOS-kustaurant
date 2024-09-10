//
//  RestaurantDetailTitle.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation

struct RestaurantDetailTitle: RestaurantDetailCellItem {
    
    let cuisineType: String
    let title: String
    let isReviewCompleted: Bool
    let address: String
    let openingHours: String
    let mapURL: URL?
    let restaurantPosition: String
    let tier: Tier?
    let isFavorite: Bool
  
    var placeId: Int? {
        guard let url = mapURL else { return nil }
        
        let urlString = url.absoluteString
        
        let pattern = "place/([0-9]+)\\?"
        let regex = try? NSRegularExpression(pattern: pattern)
        
        let nsString = urlString as NSString
        let results = regex?.matches(in: urlString, range: NSRange(location: 0, length: nsString.length))
        
        if let match = results?.first {
            let range = match.range(at: 1)
            let placeIdString = nsString.substring(with: range)
            return Int(placeIdString)
        }
        
        return nil
    }
}
