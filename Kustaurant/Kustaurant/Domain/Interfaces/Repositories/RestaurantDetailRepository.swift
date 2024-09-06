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
    func reportComment(restaurantId: Int, commentId: Int) async -> Bool
    func deleteComment(restaurantId: Int, commentId: Int) async -> Bool
    func addComment(restaurantId: Int, commentId: Int, comment: String) async -> Result<RestaurantDetailReview, NetworkError>
}

