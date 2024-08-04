//
//  Collection+.swift
//  Kustaurant
//
//  Created by 류연수 on 8/2/24.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
