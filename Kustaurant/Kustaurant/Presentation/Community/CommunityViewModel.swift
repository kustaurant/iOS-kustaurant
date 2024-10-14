//
//  CommunityViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation

protocol CommunityViewModelInput {
}

protocol CommunityViewModelOutput {
}

typealias CommunityViewModel = CommunityViewModelInput & CommunityViewModelOutput

final class DefaultCommunityViewModel: CommunityViewModel {
    private let communityUseCase: CommunityUseCases
    
    // MARK: - Initialization
    init(communityUseCase: CommunityUseCases) {
        self.communityUseCase = communityUseCase
    }
}
