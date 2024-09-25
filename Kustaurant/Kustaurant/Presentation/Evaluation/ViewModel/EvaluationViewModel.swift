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
    func selectKeyword(keyword: Category)
    func updateEvaluationReceiveData(_ data: EvaluationData)
    func updateEvaluationReceiveKeyword()
    func submitEvaluation()
}
protocol EvaluationViewModelOutput {
    var evaluationData: EvaluationDTO? { get }
    var evaluationDataPublisher: Published<EvaluationDTO?>.Publisher { get }
    var restaurantDetailTitle: RestaurantDetailTitle { get }
    var situations: [Category] { get }
    var situationsPublisher: Published<[Category]>.Publisher { get }
    var evaluationReceiveData: EvaluationData { get }
    var statePublisher: Published<DefaultEvaluationViewModel.State>.Publisher { get }
}

typealias EvaluationViewModel = EvaluationViewModelInput & EvaluationViewModelOutput

final class DefaultEvaluationViewModel: EvaluationViewModel {
    
    
    private let repository: EvaluationRepository
    private let actions: EvaluationViewModelActions

    enum State {
        case inital
        case isLoading(Bool)
        case pop
        case errorAlert(Error)
        case success
    }
    
    // MARK: - Output
    @Published var state: State = .inital
    var statePublisher: Published<State>.Publisher { $state }
    var evaluationReceiveData: EvaluationData = EvaluationData(rating: 3.0)
    @Published var evaluationData: EvaluationDTO?
    var evaluationDataPublisher: Published<EvaluationDTO?>.Publisher { $evaluationData }
    var restaurantDetailTitle: RestaurantDetailTitle
    @Published var situations: [Category] = Situation.allCases.filter({ $0 != .all }).map({ $0.category})
    var situationsPublisher: Published<[Category]>.Publisher { $situations }
    
    // MARK: - Initialization
    init(
        actions: EvaluationViewModelActions,
        repository: EvaluationRepository,
        titleData: RestaurantDetailTitle
    ) {
        self.actions = actions
        self.repository = repository
        self.restaurantDetailTitle = titleData
        
        fetch()
    }
}

extension DefaultEvaluationViewModel {
    private func fetch() {
        Task { @MainActor in
            switch await repository.fetch() {
            case .success(let success):
                evaluationData = success
                if let codes = evaluationData?.evaluationSituations?.compactMap({ $0 }).map({ String($0) }) {
                    situations = situations.map { category in
                        var modifiedCategory = category
                        if codes.contains(category.code) {
                            modifiedCategory.isSelect = true
                        }
                        return modifiedCategory
                    }
                }
                
            case .failure(let failure):
                Logger.error(failure.localizedDescription)
            }
        }
    }
    
    func submitEvaluation() {
        Task {
            state = .isLoading(true)
            
            var situations: [Int]?
            if let keywords = evaluationReceiveData.keywords {
                situations = Category.extractSituations(from: keywords).map({ Int($0.category.code) ?? 0 })
            }
            let imageData = evaluationReceiveData.image
            let evaluation = EvaluationDTO(evaluationScore: Double(evaluationReceiveData.rating),
                                           evaluationSituations: situations,
                                           evaluationImgUrl: nil,
                                           evaluationComment: evaluationReceiveData.review,
                                           starComments: nil,
                                           newImage: nil)
            let result = await repository.submitEvaluationAF(evaluation: evaluation, imageData: imageData)
            switch result {
            case .success(let comments):
                Logger.info("평가 성공 \(comments)")
                state = .success
                state = .pop
            case .failure(let error):
                state = .errorAlert(error)
            }
            
            state = .isLoading(false)
            
        }
    }
}

// MAKR: Input
extension DefaultEvaluationViewModel {
    func didTapBackButton() {
        Task {
            await MainActor.run {
                actions.pop()
            }
        }
    }
    
    func selectKeyword(keyword: Category) {
        guard let index = situations.firstIndex(where: { $0 == keyword }) else { return }
        situations[index].isSelect.toggle()
    }
    
    func updateEvaluationReceiveData(_ data: EvaluationData) {
        evaluationReceiveData = data
    }
    
    func updateEvaluationReceiveKeyword() {
        evaluationReceiveData.keywords = situations.filter({ $0.isSelect })
    }
}
