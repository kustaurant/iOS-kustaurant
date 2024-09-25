//
//  EvaluationRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import Foundation

protocol EvaluationRepository {
    func fetch() async -> Result<EvaluationDTO, NetworkError>
    func submitEvaluationAF(evaluation: EvaluationDTO, imageData: Data?, imageName: String?) async -> Result<RestaurantCommentDTO, NetworkError>
}
