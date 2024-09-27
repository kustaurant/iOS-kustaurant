//
//  DefaultEvaluationRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import Foundation
import Alamofire

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
    
    func submitEvaluationAF(
        evaluation: EvaluationDTO,
        imageData: Data?
    ) async -> Result<[RestaurantCommentDTO], NetworkError> {
        return await withCheckedContinuation { continuation in
            guard let url = URL(string: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantID)/evaluation") else {
                return continuation.resume(returning: .failure(.invalidURL))
            }
            let imageName = UUID().uuidString + ".jpg"
            guard let user: UserCredentials = KeychainStorage.shared.getValue(forKey: KeychainKey.userCredentials) else {
                return continuation.resume(returning: .failure(.custom("userCredentials")))
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(user.accessToken)",
                "Content-type": "multipart/form-data"
            ]
            
            var params: Parameters = [
                "evaluationScore": evaluation.evaluationScore ?? 3.0
            ]

            if let evaluationSituations = evaluation.evaluationSituations?.compactMap({ $0 }) {
                params["evaluationSituations"] = evaluationSituations
            }
            
            if let evaluationComment = evaluation.evaluationComment {
                params["evaluationComment"] = evaluationComment
            }
            
            AF.upload(multipartFormData: { MultipartFormData in
                if let image = imageData {
                    MultipartFormData.append(image, withName: "newImage", fileName: imageName, mimeType: "image/jpg")
                }
                
                for (key, value) in params {
                    if let arrayValue = value as? [Int] {
                        for element in arrayValue {
                            MultipartFormData.append("\(element)".data(using: .utf8)!, withName: "\(key)")
                        }
                    } else {
                        MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }
            }, to: url, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    if let decodedData = try? JSONDecoder().decode([RestaurantCommentDTO].self, from: data) {
                        continuation.resume(returning: .success(decodedData))
                    } else {
                        continuation.resume(returning: .failure(.decodingFailed))
                    }
                    
                case .failure(let error):
                    continuation.resume(returning: .failure(.custom(error.localizedDescription)))
                }
            }
        }
        
    }
}
