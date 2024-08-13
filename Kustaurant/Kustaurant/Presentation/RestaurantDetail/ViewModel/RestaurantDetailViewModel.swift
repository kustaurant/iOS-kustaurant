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
        case fetch(id: Int)
        case didTab(at: RestaurantDetailTabType)
    }
    
    enum Action {
        case didChangeTabType
    }
}

final class RestaurantDetailViewModel {
    
    private(set) var sectionHeaders: [RestaurantDetailSection: RestaurantDetailHeaderItem] = [:]
    private(set) var sectionItems: [RestaurantDetailSection: [RestaurantDetailCellItem]] = [:]
    private(set) var tabType: RestaurantDetailTabType = .menu
    
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }

}

extension RestaurantDetailViewModel {
    
    private func bind() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                    
                case .fetch(let id):
                    self?.fetch(id: id)
                    
                case .didTab(let type):
                    self?.changeTabType(as: type)
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetch(id: Int) {
        
    }
    
    private func changeTabType(as type: RestaurantDetailTabType) {
        guard tabType != type else { return }
        
        tabType = type
        actionSubject.send(.didChangeTabType)
    }
}
