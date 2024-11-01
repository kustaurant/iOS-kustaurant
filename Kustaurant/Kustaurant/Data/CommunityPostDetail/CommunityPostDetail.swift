//
//  CommunityPostDetail.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Foundation

actor CommunityPostDetail {
    typealias Items = [CommunityPostDetailSection: [CommunityPostDetailCellItem]]
    
    private var items: Items
    
    init(post: CommunityPostDTO) {
        self.items = [
            .body: [CommunityPostDetailBody(post: post)],
            .comment: post.postCommentList ?? []
        ]  
    }
    
    func updatelikeButtonStatus(_ status: CommunityLikeStatus) {
        guard var body = items[.body]?.first as? CommunityPostDetailBody else { return }
        body.updateLikeStatus(to: status)
        items[.body] = [body]
    }
    
    func updateScrapButtonStatus(_ status: CommunityScrapStatus) {
        guard var body = items[.body]?.first as? CommunityPostDetailBody else { return }
        body.updateScrapStatus(to: status)
        items[.body] = [body]
    }
 
    func getCellItems(_ section: CommunityPostDetailSection) -> [CommunityPostDetailCellItem] {
        items[section] ?? []
    }
    
}
