//
//  DrawUseCases.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/13/24.
//

import Foundation

protocol DrawUseCases {
    func getRestaurantsBy(locations: [Location], cuisines: [Cuisine]) async -> Result<[Restaurant], NetworkError>
}

final class DefaultDrawUseCases {
    private let drawRepository: DrawRepository
    
    init(drawRepository: DrawRepository) {
        self.drawRepository = drawRepository
    }
}

extension DefaultDrawUseCases: DrawUseCases {
    
    func getRestaurantsBy(locations: [Location], cuisines: [Cuisine]) async -> Result<[Restaurant], NetworkError> {
        await drawRepository.retrieveRestaurantsBy(locations: locations, cuisines: cuisines)
    }
}
