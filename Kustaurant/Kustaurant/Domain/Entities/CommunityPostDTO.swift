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
    
    struct PostComment: Codable, Hashable {
        let commentId: Int?
        let commentBody: String?
        let status: String?
        let likeCount: Int?
        let dislikeCount: Int?
        let createdAt: String?
        let updatedAt: String?
        let repliesList: [String]?
        let timeAgo: String?
        let isDisliked: Bool?
        let isLiked: Bool?
        let isCommentMine: Bool?
        let user: User?
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
    let isLiked: Bool?
    let isPostMine: Bool?
}
