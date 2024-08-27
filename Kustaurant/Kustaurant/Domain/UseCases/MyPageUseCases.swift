//
//  MyPageUseCases.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

protocol MyPageUseCases {
    
}

final class DefaultMyPageUseCases: MyPageUseCases {
    
    private let myPageRepository: MyPageRepository
    
    init(myPageRepository: MyPageRepository) {
        self.myPageRepository = myPageRepository
    }
}
    
extension DefaultMyPageUseCases {
}
