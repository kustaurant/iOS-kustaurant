//
//  DrawCollectionViewSection.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/9/24.
//

import Foundation

struct DrawCollectionViewSection {
    let type: DrawCollectionViewType
    let items: [DrawCollectionViewItem]
}

enum DrawCollectionViewType: Hashable {
    case location
    case cuisine
}

enum DrawCollectionViewItem: Hashable {
    case monoHorizontal(SelectableLocation)
    case grid(SelectableCuisine)
}
