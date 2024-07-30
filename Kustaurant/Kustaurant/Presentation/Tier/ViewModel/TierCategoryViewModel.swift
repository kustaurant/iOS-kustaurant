//
//  TierCategoryViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/30/24.
//

import Foundation

protocol TierCategoryViewModelInput {
}

protocol TierCategoryViewModelOutput {
}

typealias TierCategoryViewModel = TierCategoryViewModelInput & TierCategoryViewModelOutput

final class DefaultTierCategoryViewModel: TierCategoryViewModel {
    
}
