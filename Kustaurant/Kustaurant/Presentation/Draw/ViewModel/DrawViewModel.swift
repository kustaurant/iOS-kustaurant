//
//  DrawViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/9/24.
//

import Foundation
import Combine

struct SelectableLocation: Hashable {
    var location: Location
    var isSelected: Bool
}

struct SelectableCuisine: Hashable {
    var cuisine: Cuisine
    var isSelected: Bool
}

struct DrawViewModelActions {
    let didTapDrawButton: ([Restaurant]) -> Void
}

protocol DrawViewModelInput {
    func toggleSelectable(location: SelectableLocation) -> Void
    func toggleSelectable(cuisine: SelectableCuisine) -> Void
    func didTapDrawButton() -> Void
}

protocol DrawViewModelOutput {
    var cuisines: [SelectableCuisine] { get }
    var locations: [SelectableLocation] { get }
    var collectionViewSectionsPublisher: AnyPublisher<[DrawCollectionViewSection], Never> { get }
    var collectionViewSections: [DrawCollectionViewSection] { get }
}

typealias DrawViewModel = DrawViewModelInput & DrawViewModelOutput

final class DefaultDrawViewModel: DrawViewModel {
    
    private var actions: DrawViewModelActions
    private var drawUseCases: DrawUseCases
    
    @Published var cuisines: [SelectableCuisine] = Cuisine.allCases.map {
        if $0 == .all {
            return SelectableCuisine(cuisine: $0, isSelected: true)
        } else {
            return SelectableCuisine(cuisine: $0, isSelected: false)
        }
    }
    @Published var locations: [SelectableLocation] = Location.allCases.map {
        if $0 == .all {
            return SelectableLocation(location: $0, isSelected: true)
        } else {
            return SelectableLocation(location: $0, isSelected: false)
        }
    }
    @Published var collectionViewSections: [DrawCollectionViewSection] = []
    var collectionViewSectionsPublisher: AnyPublisher<[DrawCollectionViewSection], Never> {
        $collectionViewSections
            .eraseToAnyPublisher()
    }
    
    init(actions: DrawViewModelActions, drawUseCases: DrawUseCases) {
        self.actions = actions
        self.drawUseCases = drawUseCases
        
        Publishers.CombineLatest($locations, $cuisines)
            .map { locations, cuisines in
                [
                    DrawCollectionViewSection(
                        type: .location,
                        items: locations.map { .monoHorizontal($0) }
                    ),
                    DrawCollectionViewSection(
                        type: .cuisine,
                        items: cuisines.map { .grid($0) }
                    )
                ]
            }
            .assign(to: &$collectionViewSections)
    }
}

extension DefaultDrawViewModel {
    func toggleSelectable(location selectable: SelectableLocation) {
        if selectable.location == .all {
            for i in 0..<locations.count {
                locations[i].isSelected = (i == 0)
            }
        } else {
            locations[0].isSelected = false
            if let index = locations.firstIndex(where: { $0.location == selectable.location }) {
                locations[index].isSelected.toggle()
            }
        }
    }
    
    func toggleSelectable(cuisine selectable: SelectableCuisine) {
        if selectable.cuisine == .all {
            for i in 0..<cuisines.count {
                cuisines[i].isSelected = (i == 0)
            }
        } else {
            cuisines[0].isSelected = false
            if let index = cuisines.firstIndex(where: { $0.cuisine == selectable.cuisine }) {
                cuisines[index].isSelected.toggle()
            }
        }
    }
    
    func didTapDrawButton() {
        let selectedCuisines = cuisines.filter({ $0.isSelected }).map { $0.cuisine }
        let selectedLocations = locations.filter({ $0.isSelected }).map { $0.location }
        Task {
            let result = await drawUseCases.getRestaurantsBy(locations: selectedLocations, cuisines: selectedCuisines)
            
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let data):
                    self?.actions.didTapDrawButton(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
