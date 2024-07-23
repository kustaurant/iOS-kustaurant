//
//  TierListViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

protocol TierListViewModelInput {
}

protocol TierListViewModelOutput {
}

typealias TierListViewModel = TierListViewModelInput & TierListViewModelOutput

final class DefaultTierListViewModel: TierListViewModel {

}
