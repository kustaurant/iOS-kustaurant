//
//  CommunityPostDTO.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation

struct CommunityPostDTO: Codable, Hashable {
    struct User: Codable, Hashable {
        let userNickname: String?
        let rankImg: String?
        let evaluationCount: Int?
        let rank: Int?
    }

    struct PostComment: CommunityPostDetailCellItem, Codable, Hashable {
        let commentId: Int?
        let commentBody: String?
        let status: String?
        var likeCount: Int?
        var dislikeCount: Int?
        let createdAt: String?
        let updatedAt: String?
        let repliesList: [PostComment]?
        let timeAgo: String?
        var isDisliked: Bool?
        var isLiked: Bool?
        let isCommentMine: Bool?
        let user: User?
        
        mutating func updateComment(to newStatus: CommunityCommentStatus) {
            likeCount = newStatus.likeCount
            dislikeCount = newStatus.dislikeCount
            guard let status = newStatus.commentLikeStatus else { return }
            switch status {
            case .liked:
                isLiked = true
                isDisliked = false
            case .disliked:
                isLiked = false
                isDisliked = true
            case .none:
                isLiked = false
                isDisliked = false
            }
        }
    }
    let postId: Int?
    let postTitle: String?
    let postBody: String?
    let status: String?
    let postCategory: String?
    let createdAt: String?
    let updatedAt: String?
    let likeCount: Int?
    let user: User?
    let timeAgo: String?
    let commentCount: Int?
    let postCommentList: [PostComment]?
    let postPhotoImgUrl: String?
    let postVisitCount: Int?
    let scrapCount: Int?
    let isScraped: Bool?
    let isliked: Bool?
    let isPostMine: Bool?
}
