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
    var hasComments: Bool
    var likeCount: Int
    var dislikeCount: Int
    var likeStatus: CommentLikeStatus
    let commentId: Int
    let isCommentMine: Bool
    var commentChildrenCount: Int
    
    mutating func updateLikeStatus(to newStatus: CommentLikeStatus) {
        switch (likeStatus, newStatus) {
        case (.none, .liked):
            likeCount += 1
        case (.liked, .none):
            likeCount -= 1
        case (.none, .disliked):
            dislikeCount += 1
        case (.disliked, .none):
            dislikeCount -= 1
        case (.liked, .disliked):
            likeCount -= 1
            dislikeCount += 1
        case (.disliked, .liked):
            dislikeCount -= 1
            likeCount += 1
        default:
            break
        }
        likeStatus = newStatus
    }
}
