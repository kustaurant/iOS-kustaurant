//
//  RestaurantDetailViewModel.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import UIKit
import Combine

struct RestaurantDetailViewModelActions {
    let pop: () -> Void
    let showEvaluateScene: () -> Void
}

enum RestaurantDetailTabType: Int {
    case menu = 0
    case review
    
    init?(rawValue: Int) {
        if Self.menu.rawValue == rawValue {
            self = .menu
            return
        }
        if Self.review.rawValue == rawValue {
            self = .review
            return
        }
        return nil
    }
}

extension RestaurantDetailViewModel {
    
    enum State {
        case initial
        case fetch
        case didTab(at: RestaurantDetailTabType)
        case didTapEvaluationButton
    }
    
    enum Action {
        case didFetchItems
        case didFetchHeaderImage(UIImage)
        case didFetchReviews
        case didChangeTabType
        case loginStatus(LoginStatus)
    }
}

final class RestaurantDetailViewModel {
    
    private(set) var detail: RestaurantDetail?
    
    private let repository: any RestaurantDetailRepository
    private let authRepository: any AuthRepository
    private let actions: RestaurantDetailViewModelActions
    
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    @Published private(set) var loginStatus: LoginStatus = .notLoggedIn
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    init(
        actions: RestaurantDetailViewModelActions,
        repository: any RestaurantDetailRepository,
        authRepository: any AuthRepository
    ) {
        self.actions = actions
        self.repository = repository
        self.authRepository = authRepository
        bind()
    }
    
}

extension RestaurantDetailViewModel {
    
    private func bind() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                    
                case .fetch:
                    self?.fetch()
                    
                case .didTab(let type):
                    self?.changeTabType(as: type)
                    
                case .didTapEvaluationButton:
                    self?.actions.showEvaluateScene()
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetch() {
        Task {
            let verified = await authRepository.verifyToken()
            loginStatus = verified ? LoginStatus.loggedIn : LoginStatus.notLoggedIn
            actionSubject.send(.loginStatus(loginStatus))
            
            detail = await repository.fetch()
            
            actionSubject.send(.didFetchItems)
            
            if let url: URL = .init(string: detail?.restaurantImageURLString ?? "") {
                ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
                    if let image {
                        self?.actionSubject.send(.didFetchHeaderImage(image))
                    }
                }
            }
            
            Task {
                let reviews = await repository.fetchReviews()
                var tabItems = detail?.tabItems
                tabItems?[.review] = reviews
                await detail?.updateTabItems(as: tabItems ?? [:])
                
                if detail?.tabType == .review {
                    actionSubject.send(.didFetchReviews)
                }
            }
        }
    }
    
    private func changeTabType(as type: RestaurantDetailTabType) {
        Task {
            guard detail?.tabType != type else { return }
            
            await detail?.updateTabType(as: type)
            
            actionSubject.send(.didChangeTabType)
        }
    }
}
