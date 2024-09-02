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
    let didTapSearchButton: () -> Void
}

protocol DrawViewModelInput {
    func toggleSelectable(location: SelectableLocation) -> Void
    func toggleSelectable(cuisine: SelectableCuisine) -> Void
    func didTapDrawButton() -> Void
    func didTapOkInAlert() -> Void
    func didTapSearchButton() -> Void
}

protocol DrawViewModelOutput {
    var cuisines: [SelectableCuisine] { get }
    var locations: [SelectableLocation] { get }
    var collectionViewSectionsPublisher: AnyPublisher<[DrawCollectionViewSection], Never> { get }
    var collectionViewSections: [DrawCollectionViewSection] { get }
    var isFetchingRestaurants: Bool { get }
    var isFetchingRestaurantsPublisher: Published<Bool>.Publisher { get }
    var showAlert: Bool { get }
    var showAlertPublisher: Published<Bool>.Publisher { get }
}

typealias DrawViewModel = DrawViewModelInput & DrawViewModelOutput

final class DefaultDrawViewModel: DrawViewModel {
    
    
    @Published var isFetchingRestaurants = false
    var isFetchingRestaurantsPublisher: Published<Bool>.Publisher { $isFetchingRestaurants }
    @Published var showAlert = false
    var showAlertPublisher: Published<Bool>.Publisher { $showAlert }
    
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
        if selectable.location == .all || (selectable.isSelected && locations.filter({ $0.isSelected == true}).count == 1) {
            resetLocationsFor(location: .all)
        } else {
            deselectDesignatedLocations()
            if let index = locations.firstIndex(where: { $0.location == selectable.location }) {
                locations[index].isSelected.toggle()
            }
        }
    }
    
    func toggleSelectable(cuisine selectable: SelectableCuisine) {
        if selectable.cuisine == .all || (selectable.isSelected && cuisines.filter({ $0.isSelected == true}).count == 1) {
            resetCuisinesFor(cuisine: .all)
        } else if selectable.cuisine == .jh || (selectable.isSelected && cuisines.filter({ $0.isSelected == true}).count == 1)  {
            resetCuisinesFor(cuisine: .jh)
        } else {
            deselectDesignatedCuisines()
            if let index = cuisines.firstIndex(where: { $0.cuisine == selectable.cuisine }) {
                cuisines[index].isSelected.toggle()
            }
        }
    }
    
    private func resetCuisinesFor(cuisine: Cuisine) {
        for i in 0..<cuisines.count {
            cuisines[i].isSelected = (cuisines[i].cuisine == cuisine)
        }
    }
    
    private func resetLocationsFor(location: Location) {
        for i in 0..<locations.count {
            locations[i].isSelected = (locations[i].location == location)
        }
    }
    
    private func deselectDesignatedCuisines() {
        for index in 0..<cuisines.count {
            if cuisines[index].cuisine == .all || cuisines[index].cuisine == .jh {
                cuisines[index].isSelected = false
            }
        }
    }
    
    private func deselectDesignatedLocations() {
        for index in 0..<locations.count {
            if locations[index].location == .all {
                locations[index].isSelected = false
            }
        }
    }
}

extension DefaultDrawViewModel {
    
    func didTapDrawButton() {
        isFetchingRestaurants = true
        let selectedCuisines = cuisines.filter({ $0.isSelected }).map { $0.cuisine }
        let selectedLocations = locations.filter({ $0.isSelected }).map { $0.location }
        Task {
            let result = await drawUseCases.getRestaurantsBy(locations: selectedLocations, cuisines: selectedCuisines)
            
            DispatchQueue.main.async { [weak self] in
                defer { self?.isFetchingRestaurants = false }
                switch result {
                case .success(let data):
                    self?.actions.didTapDrawButton(data)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.showAlert = true
                }
            }
        }
    }
    
    func didTapOkInAlert() {
        showAlert = false
    }
    
    func didTapSearchButton() {
        actions.didTapSearchButton()
    }
}
