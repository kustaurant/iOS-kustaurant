//
//  CommunityScrapStatus.swift
//  Kustaurant
//
//  Created by 송우진 on 10/31/24.
//

import Foundation

struct CommunityScrapStatus: Codable {
    let scrapCount: Int?
    let status: Int?
    
    enum CodingKeys: CodingKey {
        case scrapCount, status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scrapCount = try? container.decodeIfPresent(Int.self, forKey: .scrapCount)
        status = try? container.decodeIfPresent(Int.self, forKey: .status)
    }
    
    func isScrapped() -> Bool {
        guard let status else { return false }
        return (status == 0) ? false : true
    }
}
