//
//  MyEvaluationViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/7/24.
//

import Foundation

struct MyEvaluationViewModelActions {
    let pop: () -> Void
    let showRestaurantDetail: (Int) -> Void
}

protocol MyEvaluationViewModelInput {
    func getEvaluatedRestaurants()
    func didTapBackButton()
    func didTapRestaurant(restaurantId: Int)
}

protocol MyEvaluationViewModelOutput {
    var evaluatedRestaurants: [EvaluatedRestaurant] { get }
    var evaluatedRestaurantsPublisher: Published<[EvaluatedRestaurant]>.Publisher { get }
}

typealias MyEvaluationViewModel = MyEvaluationViewModelInput & MyEvaluationViewModelOutput

final class DefaultMyEvaluationViewModel: MyEvaluationViewModel {

    @Published var evaluatedRestaurants: [EvaluatedRestaurant] = []
    var evaluatedRestaurantsPublisher: Published<[EvaluatedRestaurant]>.Publisher { $evaluatedRestaurants }
    
    private let actions: MyEvaluationViewModelActions
    private let myPageUseCases: MyPageUseCases
    
    init(actions: MyEvaluationViewModelActions, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultMyEvaluationViewModel {
    
    func didTapBackButton() {
        actions.pop()
    }
    
    func getEvaluatedRestaurants() {
        Task {
            let result = await myPageUseCases.getEvaluatedRestaurants()
            await MainActor.run {
                switch result {
                case .success(let data):
                    evaluatedRestaurants = data
                case .failure:
                    return
                }
            }
        }
    }
    
    func didTapRestaurant(restaurantId: Int) {
        actions.showRestaurantDetail(restaurantId)
    }
}
