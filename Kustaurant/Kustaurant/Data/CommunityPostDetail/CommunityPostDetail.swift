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
    
    func updateCommentLikeStatus(
        id commentId: Int,
        status: CommunityCommentStatus
    ) {
        guard let comments = items[.comment] else { return }
        let list = comments.map({ $0 as? CommunityPostDTO.PostComment }).compactMap({ $0 })
        guard let index = list.firstIndex(where: { $0.commentId == commentId }) else { return }

        var model = list[index]
        model.updateComment(to: status)
        items[.comment]?[index] = model
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
