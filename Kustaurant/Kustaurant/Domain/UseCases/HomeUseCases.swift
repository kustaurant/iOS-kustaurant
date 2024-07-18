//
//  HomeUseCases.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import Foundation

protocol HomeUseCases {
    func fetchRestaurantLists() async -> Result<HomeRestaurantLists, NetworkError>
}

final class DefaultHomeUseCases {
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
}

extension DefaultHomeUseCases: HomeUseCases {
    func fetchRestaurantLists() async -> Result<HomeRestaurantLists, NetworkError> {
        await homeRepository.fetchRestaurantLists()
    }
}
