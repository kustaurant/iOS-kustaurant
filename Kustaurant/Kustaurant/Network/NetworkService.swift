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
    func getCommunityPostDetailURL(_ postId: Int) -> String {
        "/api/v1/community/\(postId)"
    }
    func postCommunityPostLikeToggle(_ postId: Int) -> String {
        "/api/v1/auth/community/\(postId)/likes"
    }
    func postCommunityPostScrapToggle(_ postId: Int) -> String {
        "/api/v1/auth/community/\(postId)/scraps"
    }
}
