//
//  CommunityRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation

protocol CommunityRepository {
    func getPosts(category: CommunityPostCategory, page: Int, sort: CommunityPostSortType) async -> Result<[CommunityPostDTO], NetworkError>
}
