//
//  CommunityPostDetailBody.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Foundation

struct CommunityPostDetailBody: CommunityPostDetailCellItem, Hashable {
    let postTitle: String
    let postBody: String?
    let timeAgo: String
    let user: CommunityPostDTO.User?
    let postPhotoImgUrl: String?
    let postVisitCount: Int
    let commentCount: Int
    var likeCount: Int
    var scrapCount: Int
    var isScraped: Bool
    var isliked: Bool
    let isPostMine: Bool
    
    init(post: CommunityPostDTO) {
        let null = "NULL"
        postTitle = post.postTitle ?? null
        postBody = post.postBody
        timeAgo = post.timeAgo ?? null
        user = post.user
        postPhotoImgUrl = post.postPhotoImgUrl
        postVisitCount = post.postVisitCount ?? 0
        commentCount = post.commentCount ?? 0
        likeCount = post.likeCount ?? 0
        scrapCount = post.scrapCount ?? 0
        isScraped = post.isScraped ?? false
        isliked = post.isliked ?? false
        isPostMine = post.isPostMine ?? false
    }
    
    mutating func updateLikeStatus(to newStatus: CommunityLikeStatus) {
        likeCount = newStatus.likeCount ?? likeCount
        isliked = newStatus.isLikeed()
    }
    
    mutating func updateScrapStatus(to newStatus: CommunityScrapStatus) {
        scrapCount = newStatus.scrapCount ?? scrapCount
        isScraped = newStatus.isScrapped()
    }
}
