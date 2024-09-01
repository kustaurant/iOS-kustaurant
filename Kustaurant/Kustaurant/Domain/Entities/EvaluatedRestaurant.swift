//
//  EvaluatedRestaurant.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

struct EvaluatedRestaurant: Codable {
    let restaurantName: String?
    let restaurantImgURL: String?
    let cuisine: String?
    let evaluationStore: Int?
    let restaurantComment: String?
    let evaluationItemScores: String?
}
