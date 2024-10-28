//
//  CommunityPostDetail.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Foundation

actor CommunityPostDetail {
    typealias Items = [CommunityPostDetailSection: [CommunityPostDetailCellItem]]
    
    private let items: Items
    
    init(post: CommunityPostDTO) {
        self.items = [
            .body: [CommunityPostDetailBody(post: post)],
            .comment: []
        ]
    }
    
    func getCellItems(_ section: CommunityPostDetailSection) -> [CommunityPostDetailCellItem] {
        items[section] ?? []
    }
}
