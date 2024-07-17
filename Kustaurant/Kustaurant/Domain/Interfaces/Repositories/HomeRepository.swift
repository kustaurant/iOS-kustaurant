//
//  HomeRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import Foundation

protocol HomeRepository {
    func fetchRestaurantLists() async -> Result<HomeRestaurantLists, NetworkError>
}
