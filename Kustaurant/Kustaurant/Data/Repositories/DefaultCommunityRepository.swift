//
//  DefaultCommunityRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation

final class DefaultCommunityRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultCommunityRepository: CommunityRepository {
    func postCommunityPostLikeToggle(postId: Int) async -> Result<CommunityLikeStatus, NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let urlBuilder = URLRequestBuilder(
            url: networkService.appConfiguration.apiBaseURL + networkService.postCommunityPostLikeToggle(postId),
            method: .post
        )
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: CommunityLikeStatus = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
    
    func getPostDetail(postId: Int) async -> Result<CommunityPostDTO, NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + networkService.getCommunityPostDetailURL(postId))
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: CommunityPostDTO = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
    
    func getPosts(
        category: CommunityPostCategory,
        page: Int,
        sort: CommunityPostSortType
    ) async -> Result<[CommunityPostDTO], NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + networkService.getCommunityPostsURL)
        urlBuilder.addQuery(parameter: [
            "postCategory" : String(describing: category),
            "page" : "\(page)",
            "sort" : String(describing: sort)
        ])
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)

        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: [CommunityPostDTO] = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
}
