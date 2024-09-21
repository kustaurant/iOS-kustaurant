//
//  DefaultMyPageRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

final class DefaultMyPageRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultMyPageRepository: MyPageRepository {
    
    func sendFeedback(_ comments: String) async -> Result<Void, NetworkError> {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/mypage/feedback", method: .post)
        urlBuilder.addContentType(.applicationJson)
        
        let paramters = [
            "comments": comments
        ]
        
        if let body = try? JSONSerialization.data(withJSONObject: paramters) {
            urlBuilder.setBody(body)
        } else {
            return .failure(.invalidRequest)
        }
        
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        return .success(())
    }
    
    func updateUserPrfile(_ userProfile: UserProfile) async -> Result<Void, NetworkError> {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/mypage/profile", method: .patch)
        urlBuilder.addContentType(.applicationJson)
        
        if let body = try? JSONEncoder().encode(userProfile) {
            urlBuilder.setBody(body)
        } else {
            return .failure(.invalidRequest)
        }
        
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        return .success(())
    }
    
    func fetchSavedRestaurantsCount() async -> Result<UserSavedRestaurantsCount, NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/mypage")
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: UserSavedRestaurantsCount = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
    
    func fetchFavoriteRestaurants() async -> Result<[FavoriteRestaurant], NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/mypage/favorite-restaurant-list")
        
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: [FavoriteRestaurant] = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
    
    func fetchEvaluatedRestaurants() async -> Result<[EvaluatedRestaurant], NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/mypage/evaluate-restaurant-list")
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: [EvaluatedRestaurant] = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
    
    func fetchUserProfile() async -> Result<UserProfile, NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/mypage/profile")
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: UserProfile = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
    
    func fetchNoticeList() async -> Result<[Notice], NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/mypage/noticelist")
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: [Notice] = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
}
