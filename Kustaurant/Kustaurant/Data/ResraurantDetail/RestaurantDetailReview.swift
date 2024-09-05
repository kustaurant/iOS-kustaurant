//
//  RestaurantDetailReview.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation

struct RestaurantDetailReview: RestaurantDetailCellItem {
    
    let profileImageURLString: String
    let nickname: String
    let time: String
    let photoImageURLString: String
    let review: String
    let rating: Double?
    let isComment: Bool
    let hasComments: Bool
    let likeCount: Int
    let dislikeCount: Int
    let likeStatus: CommentLikeStatus
    let commentId: Int
}
