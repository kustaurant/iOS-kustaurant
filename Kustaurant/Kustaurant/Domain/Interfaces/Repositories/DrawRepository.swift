//
//  DrawRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/13/24.
//

import Foundation

protocol DrawRepository {
    func retrieveRestaurantsBy(locations: [Location], cuisines: [Cuisine]) async -> Result<[Restaurant], NetworkError>
}
