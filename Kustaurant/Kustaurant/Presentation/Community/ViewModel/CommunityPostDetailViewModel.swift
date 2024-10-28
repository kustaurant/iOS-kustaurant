//
//  CommunityPostDetailViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Foundation

protocol CommunityPostDetailViewModelInput {}
protocol CommunityPostDetailViewModelOutput {}

typealias CommunityPostDetailViewModel = CommunityPostDetailViewModelInput & CommunityPostDetailViewModelOutput

final class DefaultCommunityPostDetailViewModel: CommunityPostDetailViewModel {
    private let communityUseCase: CommunityUseCases
    
    // MARK: - Initialization
    init(communityUseCase: CommunityUseCases) {
        self.communityUseCase = communityUseCase
    }
}
