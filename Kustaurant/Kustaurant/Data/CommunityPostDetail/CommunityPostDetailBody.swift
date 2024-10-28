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
    let likeCount: Int
    let scrapCount: Int
    
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
    }
}
