//
//  DrawResultViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/10/24.
//

import Foundation

protocol DrawResultViewModelInput {}
protocol DrawResultViewModelOutput {}

typealias DrawResultViewModel = DrawResultViewModelInput & DrawResultViewModelOutput

final class DefaultDrawResultViewModel: DrawResultViewModel {
}
