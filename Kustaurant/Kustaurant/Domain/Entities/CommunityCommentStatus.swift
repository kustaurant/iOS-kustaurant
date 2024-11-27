//
//  CommunityCommentStatus.swift
//  Kustaurant
//
//  Created by 송우진 on 11/3/24.
//

import Foundation

struct CommunityCommentStatus: Codable {
    let likeCount: Int?
    let dislikeCount: Int?
    let commentLikeStatus: CommentLikeStatus?
}
