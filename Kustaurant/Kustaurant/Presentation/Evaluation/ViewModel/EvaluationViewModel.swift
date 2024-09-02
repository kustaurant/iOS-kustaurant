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
    
    private let actions: EvaluationViewModelActions
    
    init(actions: EvaluationViewModelActions) {
        self.actions = actions
    }
}

extension DefaultEvaluationViewModel {
    
    func didTapBackButton() {
        actions.pop()
    }
}
