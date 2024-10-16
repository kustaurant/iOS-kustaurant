//
//  CommunityUseCases.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation

protocol CommunityUseCases {
    func fetchPosts(category: CommunityPostCategory, page: Int, sort: CommunityPostSortType) async -> Result<[CommunityPostDTO], NetworkError>
}

final class DefaultCommunityUseCases {
    private let communityRepository: CommunityRepository

    init(communityRepository: CommunityRepository) {
        self.communityRepository = communityRepository
    }
}

extension DefaultCommunityUseCases: CommunityUseCases {
    func fetchPosts(
        category: CommunityPostCategory,
        page: Int,
        sort: CommunityPostSortType
    ) async -> Result<[CommunityPostDTO], NetworkError> {
        await communityRepository.getPosts(category: category, page: page, sort: sort)
    }
    
    
}
