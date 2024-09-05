//
//  RestaurantCommentDTO.swift
//  Kustaurant
//
//  Created by 류연수 on 8/15/24.
//

import Foundation

struct RestaurantCommentDTO: Decodable {
    let commentID: Int?
    let commentScore: Double?
    let commentIconImageURLString: String?
    let commentNickname: String?
    let commentTime: String?
    let commentImageURLString: String?
    let commentBody: String?
    let commentLikeStatus: CommentLikeStatus?
    let commentLikeCount: Int?
    let commentDislikeCount: Int?
    let isCommentMine: Bool?
    let commentReplies: [RestaurantCommentDTO]?
    
    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case commentScore = "commentScore"
        case commentIconImageURLString = "commentIconImgUrl"
        case commentNickname = "commentNickname"
        case commentTime = "commentTime"
        case commentImageURLString = "commentImgUrl"
        case commentBody = "commentBody"
        case commentLikeStatus = "commentLikeStatus"
        case commentLikeCount = "commentLikeCount"
        case commentDislikeCount = "commentDislikeCount"
        case isCommentMine = "isCommentMine"
        case commentReplies = "commentReplies"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        commentID = try container.decodeIfPresent(Int.self, forKey: .commentID)
        commentScore = try? container.decodeIfPresent(Double.self, forKey: .commentScore)
        commentIconImageURLString = try? container.decodeIfPresent(String.self, forKey: .commentIconImageURLString)
        commentNickname = try? container.decodeIfPresent(String.self, forKey: .commentNickname)
        commentTime = try? container.decodeIfPresent(String.self, forKey: .commentTime)
        commentImageURLString = try? container.decodeIfPresent(String.self, forKey: .commentImageURLString)
        commentBody = try? container.decodeIfPresent(String.self, forKey: .commentBody)
        commentLikeStatus = try? container.decodeIfPresent(CommentLikeStatus.self, forKey: .commentLikeStatus)
        commentLikeCount = try? container.decodeIfPresent(Int.self, forKey: .commentLikeCount)
        commentDislikeCount = try? container.decodeIfPresent(Int.self, forKey: .commentDislikeCount)
        isCommentMine = try? container.decodeIfPresent(Bool.self, forKey: .isCommentMine)
        commentReplies = try? container.decodeIfPresent([RestaurantCommentDTO].self, forKey: .commentReplies)
    }
}
