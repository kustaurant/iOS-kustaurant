//
//  SearchRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation

protocol SearchRepository {
    func search(term: String) async -> Result<[Restaurant], NetworkError>
}
