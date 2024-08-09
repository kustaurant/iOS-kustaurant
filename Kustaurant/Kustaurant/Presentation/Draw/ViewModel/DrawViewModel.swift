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

protocol DrawViewModelInput {
    func toggleSelectable(location: SelectableLocation) -> Void
    func toggleSelectable(cuisine: SelectableCuisine) -> Void
}

protocol DrawViewModelOutput {
    var cuisines: [SelectableCuisine] { get }
    var locations: [SelectableLocation] { get }
    var collectionViewSectionsPublisher: AnyPublisher<[DrawCollectionViewSection], Never> { get }
    var collectionViewSections: [DrawCollectionViewSection] { get }
}

typealias DrawViewModel = DrawViewModelInput & DrawViewModelOutput

final class DefaultDrawViewModel: DrawViewModel {
    
    @Published var cuisines: [SelectableCuisine] = Cuisine.allCases.map { SelectableCuisine(cuisine: $0, isSelected: false) }
    @Published var locations: [SelectableLocation] = Location.allCases.map { SelectableLocation(location: $0, isSelected: false) }
    @Published var collectionViewSections: [DrawCollectionViewSection] = []
    var collectionViewSectionsPublisher: AnyPublisher<[DrawCollectionViewSection], Never> {
        $collectionViewSections
            .eraseToAnyPublisher()
    }
    
    init() {
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
    func toggleSelectable(location: SelectableLocation) {
        if let index = locations.firstIndex(where: { $0.location == location.location }) {
            locations[index].isSelected.toggle()
        }
    }
    
    func toggleSelectable(cuisine: SelectableCuisine) {
        if let index = cuisines.firstIndex(where: { $0.cuisine == cuisine.cuisine }) {
            cuisines[index].isSelected.toggle()
        }
    }
}
