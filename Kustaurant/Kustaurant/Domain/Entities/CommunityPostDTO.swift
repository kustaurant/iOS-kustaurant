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
        var isReply: Bool = false
        
        enum CodingKeys: String, CodingKey {
            case commentId, commentBody, status, likeCount, dislikeCount, createdAt, updatedAt, repliesList, timeAgo, isDisliked, isLiked, isCommentMine, user
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            commentId = try? container.decode(Int.self, forKey: .commentId)
            commentBody = try? container.decode(String.self, forKey: .commentBody)
            status = try? container.decode(String.self, forKey: .status)
            likeCount = try? container.decode(Int.self, forKey: .likeCount)
            dislikeCount = try? container.decode(Int.self, forKey: .dislikeCount)
            createdAt = try? container.decode(String.self, forKey: .createdAt)
            updatedAt = try? container.decode(String.self, forKey: .updatedAt)
            repliesList = try? container.decode([PostComment].self, forKey: .repliesList)
            timeAgo = try? container.decode(String.self, forKey: .timeAgo)
            isDisliked = try? container.decode(Bool.self, forKey: .isDisliked)
            isLiked = try? container.decode(Bool.self, forKey: .isLiked)
            isCommentMine = try? container.decode(Bool.self, forKey: .isCommentMine)
            user = try? container.decode(User.self, forKey: .user)
            isReply = false // 기본값 설정
        }
        
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
    var postCommentList: [PostComment]?
    let postPhotoImgUrl: String?
    let postVisitCount: Int?
    let scrapCount: Int?
    let isScraped: Bool?
    let isliked: Bool?
    let isPostMine: Bool?
}
