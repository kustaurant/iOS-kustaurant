//
//  CommunityLikeStatus.swift
//  Kustaurant
//
//  Created by 송우진 on 10/30/24.
//

import Foundation

struct CommunityLikeStatus: Codable {
    let likeCount: Int?
    let status: Int?
    
    enum CodingKeys: CodingKey {
        case likeCount, status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        likeCount = try? container.decodeIfPresent(Int.self, forKey: .likeCount)
        status = try? container.decodeIfPresent(Int.self, forKey: .status)
    }
    
    func isLikeed() -> Bool {
        guard let status else { return false }
        return (status == 0) ? false : true
    }
}
