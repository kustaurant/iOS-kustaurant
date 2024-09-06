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
protocol EvaluationViewModelOutput {
    var evaluationDataPublisher: Published<EvaluationDTO?>.Publisher { get }
}

typealias EvaluationViewModel = EvaluationViewModelInput & EvaluationViewModelOutput

final class DefaultEvaluationViewModel: EvaluationViewModel {
    
    private let repository: EvaluationRepository
    private let actions: EvaluationViewModelActions
    
    @Published private(set) var evaluationData: EvaluationDTO?
    
    // MARK: - Output
    var evaluationDataPublisher: Published<EvaluationDTO?>.Publisher { $evaluationData }
    
    // MARK: - Initialization
    init(
        actions: EvaluationViewModelActions,
        repository: EvaluationRepository
    ) {
        self.actions = actions
        self.repository = repository

        fetch()
    }
}

extension DefaultEvaluationViewModel {
    private func fetch() {
        Task {
            switch await repository.fetch() {
            case .success(let success):
                evaluationData = success
            case .failure(let failure):
                Logger.error(failure.localizedDescription)
            }
        }
    }
}

// MAKR: Input
extension DefaultEvaluationViewModel {
    
    func didTapBackButton() {
        actions.pop()
    }
}
