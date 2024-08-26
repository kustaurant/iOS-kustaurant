//
//  SearchUseCases.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation

protocol SearchUseCases {
    
    func search(term: String) async -> Result<[Restaurant], NetworkError>
}

final class DefaultSearchUseCases {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
}

extension DefaultSearchUseCases: SearchUseCases {
    
    func search(term: String) async -> Result<[Restaurant], NetworkError> {
        await searchRepository.search(term: term)
    }
}
