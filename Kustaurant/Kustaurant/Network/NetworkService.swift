//
//  NetworkService.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import Foundation

final class NetworkService {
    lazy var appConfiguration = AppConfiguration()
    
    let getCommunityPostsURL = "/api/v1/community/posts"
    let postCommnunityPostCreateURL = "/api/v1/auth/community/posts/create"
    
    func getCommunityPostDetailURL(_ postId: Int) -> String {
        "/api/v1/community/\(postId)"
    }
    func postCommunityPostLikeToggle(_ postId: Int) -> String {
        "/api/v1/auth/community/\(postId)/likes"
    }
    func postCommunityPostScrapToggle(_ postId: Int) -> String {
        "/api/v1/auth/community/\(postId)/scraps"
    }
    
    func postCommunityCommentLike(
        _ commentId: Int,
        _ action: CommentActionType
    ) -> String {
        "/api/v1/auth/community/comments/\(commentId)/\(String(describing: action))"
    }
    
    func deleteCommunityComment(_ commentId: Int) -> String {
        "/api/v1/auth/community/comment/\(commentId)"
    }
}
