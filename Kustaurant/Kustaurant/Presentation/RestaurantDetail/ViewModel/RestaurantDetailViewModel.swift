//
//  RestaurantDetailViewModel.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import Foundation
import Combine

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
    }
    
    enum Action {
        case didfetchItems
        case didChangeTabType
    }
}

final class RestaurantDetailViewModel {
    
    typealias Sections = [RestaurantDetailSection: RestaurantDetailHeaderItem]
    typealias Items = [RestaurantDetailSection: [RestaurantDetailCellItem]]
    
    private(set) var sectionHeaders: Sections = [:]
    private(set) var sectionItems: Items = [:]
    private(set) var tabType: RestaurantDetailTabType = .menu
    private var tabItems: [RestaurantDetailTabType: [RestaurantDetailCellItem]] = [:]
    
    private let repository: any RestaurantDetailRepository
    
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    init(repository: any RestaurantDetailRepository) {
        self.repository = repository
        
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
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetch() {
        Task {
            let items = await repository.fetch()
            let reviewItems = await repository.fetchReviews()
            
            sectionHeaders = items.0 as? Sections ?? [:]
            sectionItems = items.1 as? Items ?? [:]
            tabItems[.menu] = sectionItems[.tab]
            tabItems[.review] = reviewItems
            
            actionSubject.send(.didfetchItems)
        }
    }
    
    private func changeTabType(as type: RestaurantDetailTabType) {
        guard tabType != type else { return }
        
        tabType = type
        sectionItems[.tab] = tabItems[tabType]
        
        actionSubject.send(.didChangeTabType)
    }
}
