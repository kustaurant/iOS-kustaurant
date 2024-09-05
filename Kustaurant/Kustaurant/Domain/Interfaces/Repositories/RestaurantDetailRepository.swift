//
//  RestaurantDetailRepository.swift
//  Kustaurant
//
//  Created by 류연수 on 8/13/24.
//

import Foundation

protocol RestaurantDetailRepository {
    
    func fetch() async -> RestaurantDetail
    func fetchReviews() async -> [RestaurantDetailCellItem]
    func likeComment(restaurantId: Int, commentId: Int) async -> Result<RestaurantCommentDTO, NetworkError>
    func dislikeComment(restaurantId: Int, commentId: Int) async -> Result<RestaurantCommentDTO, NetworkError>
}

