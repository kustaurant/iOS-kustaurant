//
//  RestaurantComment.swift
//  Kustaurant
//
//  Created by 류연수 on 8/15/24.
//

import Foundation

struct RestaurantComment: Decodable {
    let commentID: Int
    let commentScore: Double?
    let commentIconImageURLString: String?
    let commentNickname: String?
    let commentTime: String?
    let commentImageURLString: String?
    let commentBody: String?
    let commentLikeStatus: Int?
    let commentLikeCount: Int?
    let commentDislikeCount: Int?
    let commentReplies: [String]?
    
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
        case commentReplies = "commentReplies"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        commentID = try container.decode(Int.self, forKey: .commentID)
        commentScore = try? container.decodeIfPresent(Double.self, forKey: .commentScore)
        commentIconImageURLString = try? container.decodeIfPresent(String.self, forKey: .commentIconImageURLString)
        commentNickname = try? container.decodeIfPresent(String.self, forKey: .commentNickname)
        commentTime = try? container.decodeIfPresent(String.self, forKey: .commentTime)
        commentImageURLString = try? container.decodeIfPresent(String.self, forKey: .commentImageURLString)
        commentBody = try? container.decodeIfPresent(String.self, forKey: .commentBody)
        commentLikeStatus = try? container.decodeIfPresent(Int.self, forKey: .commentLikeStatus)
        commentLikeCount = try? container.decodeIfPresent(Int.self, forKey: .commentLikeCount)
        commentDislikeCount = try? container.decodeIfPresent(Int.self, forKey: .commentDislikeCount)
        commentReplies = try? container.decodeIfPresent([String].self, forKey: .commentReplies)
    }
}
