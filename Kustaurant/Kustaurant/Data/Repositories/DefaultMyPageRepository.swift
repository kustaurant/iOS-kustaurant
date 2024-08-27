//
//  DefaultMyPageRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

final class DefaultMyPageRepository: MyPageRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultMyPageRepository {
}
