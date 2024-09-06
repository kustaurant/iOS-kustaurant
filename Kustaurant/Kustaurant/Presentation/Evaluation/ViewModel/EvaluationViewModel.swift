//
//  EvaluationViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import Foundation

struct EvaluationViewModelActions {
    let pop: () -> Void
}

protocol EvaluationViewModelInput {
    func didTapBackButton()
}
protocol EvaluationViewModelOutput {}

typealias EvaluationViewModel = EvaluationViewModelInput & EvaluationViewModelOutput

final class DefaultEvaluationViewModel: EvaluationViewModel {
    
    private let repository: any EvaluationRepository
    private let actions: EvaluationViewModelActions
    
    init(
        actions: EvaluationViewModelActions,
        repository: any EvaluationRepository
    ) {
        self.actions = actions
        self.repository = repository
    }
}

extension DefaultEvaluationViewModel {
    
    func didTapBackButton() {
        actions.pop()
    }
}
