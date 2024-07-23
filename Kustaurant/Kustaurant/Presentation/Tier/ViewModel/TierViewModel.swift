//
//  TierViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

protocol TierViewModelInput {
}

protocol TierViewModelOutput {
}

typealias TierViewModel = TierViewModelInput & TierViewModelOutput

final class DefaultTierViewModel: TierViewModel {

}
