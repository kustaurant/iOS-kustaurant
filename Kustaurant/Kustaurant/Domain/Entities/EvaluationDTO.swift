//
//  EvaluationDTO.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import Foundation

struct EvaluationDTO: Codable {
    let evaluationScore: Double?
    let evaluationSituations: [Int?]?
    let evaluationImgUrl: String?
    let evaluationComment: String?
    let starComments: [EvaluationStarComment?]?
    let newImage: String?
    
    struct EvaluationStarComment: Codable {
        var star: Double?
        var comment: String?
    }
}
