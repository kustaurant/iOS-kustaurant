//
//  DefaultEvaluationRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import Foundation
//import Alamofire

final class DefaultEvaluationRepository: EvaluationRepository {
    
    private let networkService: NetworkService
    private let restaurantID: Int
    
    init(
        networkService: NetworkService,
        restaurantID: Int
    ) {
        self.networkService = networkService
        self.restaurantID = restaurantID
    }
}

extension DefaultEvaluationRepository {
    func fetch() async -> Result<EvaluationDTO, NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantID)/evaluation")
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: EvaluationDTO = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
    
    func submitEvaluationAF(evaluation: EvaluationDTO, imageData: Data?, imageName: String?) async -> Result<RestaurantCommentDTO, NetworkError> {
        // 파라미터
        return await withCheckedContinuation { continuation in
//            let header: HTTPHeaders = [ "Content-Type" : "multipart/form-data" ]
                
            let imageName = UUID().uuidString + ".jpg"
//            let params: Parameters = [
//                "evaluationScore": 3.0,
//                "evaluationSituations": [1, 8],
//                "evaluationComment": "맛있고 양 많아요!",
//                "newImage" : imageName
//            ]
//                
            guard let url = URL(string: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantID)/evaluation") else {
                return continuation.resume(returning: .failure(.invalidURL))
            }
            
//            AF.upload(multipartFormData: { MultipartFormData in
//                for (key, value) in params {
//                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//                if let image = imageData {
//                    MultipartFormData.append(image, withName: "image", fileName: imageName, mimeType: "image/jpg")
//                }
//            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header).responseData { response in
//                switch response.result {
//                case .success(let data):
//                    if let decodedData = try? JSONDecoder().decode(RestaurantCommentDTO.self, from: data) {
//                        continuation.resume(returning: .success(decodedData))
//                    } else {
//                        continuation.resume(returning: .failure(.decodingFailed))
//                    }
//                    
//                case .failure(let error):
//                    continuation.resume(returning: .failure(.custom(error.localizedDescription)))
//                }
//            }
        }
        
    }
}
