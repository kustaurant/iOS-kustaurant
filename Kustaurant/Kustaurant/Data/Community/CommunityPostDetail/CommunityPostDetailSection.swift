//
//  CommunityPostDetailSection.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Foundation

enum CommunityPostDetailSection: CaseIterable {
    case body
    case comment
    
    var index: Int {
        switch self {
        case .body: 0
        case .comment: 1
        }
    }
    
    static var count: Int {
        Self.allCases.count
    }
}
