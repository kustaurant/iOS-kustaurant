//
//  EvaluationRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import Foundation

protocol EvaluationRepository {
}

final class DefaultEvaluationRepositoryRepository: EvaluationRepository {
    
    private let networkService: NetworkService
    private let restaurantID: Int
    
    init(networkService: NetworkService, restaurantID: Int) {
        self.networkService = networkService
        self.restaurantID = restaurantID
    }
}
