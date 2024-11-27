//
//  DefaultCommunityRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation
import Alamofire

final class DefaultCommunityRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultCommunityRepository: CommunityRepository {
    func writeComment(
        postId: String,
        parentCommentId: String?,
        content: String
    ) async -> Result<CommunityPostDTO.PostComment, NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        var urlBuilder = URLRequestBuilder(
            url: networkService.appConfiguration.apiBaseURL + networkService.postCommunityPostWriteComment,
            method: .post
        )
        var params: [String: String] = [
            "content" : content,
            "postId" : postId
        ]
        if let parentCommentId {
            params["parentCommentId"] = parentCommentId
        }
        urlBuilder.addQuery(parameter: params)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: CommunityPostDTO.PostComment = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
    func deletePost(postId: Int) async -> Result<Void, NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let urlBuilder = URLRequestBuilder(
            url: networkService.appConfiguration.apiBaseURL + networkService.deleteCommunityPost(postId),
            method: .delete
        )
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        return .success(())
    }
    
    func uploadImage(imageData: Data?) async -> Result<UploadImageResponse, NetworkError> {
        return await withCheckedContinuation { continuation in
            guard let imageData else { return continuation.resume(returning: .failure(.noData))}
            guard let url = URL(string: networkService.appConfiguration.apiBaseURL + networkService.postCommunityPostUploadImage) else {
                return continuation.resume(returning: .failure(.invalidURL))
            }
            guard let user: UserCredentials = KeychainStorage.shared.getValue(forKey: KeychainKey.userCredentials) else {
                return continuation.resume(returning: .failure(.custom("userCredentials")))
            }
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(user.accessToken)",
                "Content-type": "multipart/form-data"
            ]
            let imageName = UUID().uuidString + ".jpg"
            AF.upload(multipartFormData: { MultipartFormData in
                MultipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpg")
            }, to: url, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    if let decodedData = try? JSONDecoder().decode(UploadImageResponse.self, from: data) {
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
    
    func createPost(
        title: String,
        postCategory: String,
        content: String,
        imageFile: String?
    ) async -> Result<CommunityPostDTO, NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        var urlBuilder = URLRequestBuilder(
            url: networkService.appConfiguration.apiBaseURL + networkService.postCommnunityPostCreateURL,
            method: .post
        )
        var params: [String: String] = [
            "title" : title,
            "postCategory" : postCategory,
            "content" : content
        ]
        if let imageFile {
            params["imageFile"] = imageFile
        }
        urlBuilder.addQuery(parameter: params)
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
    
    func deleteCommunityComment(commentId: Int) async -> Result<Void, NetworkError> {
        let urlBuilder = URLRequestBuilder(
            url: networkService.appConfiguration.apiBaseURL + networkService.deleteCommunityComment(commentId),
            method: .delete
        )
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }

        return .success(())
    }
    
    func postCommunityCommentLikeToggle(
        commentId: Int,
        action: CommentActionType
    ) async -> Result<CommunityCommentStatus, NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let urlBuilder = URLRequestBuilder(
            url: networkService.appConfiguration.apiBaseURL + networkService.postCommunityCommentLike(commentId, action),
            method: .post
        )
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: CommunityCommentStatus = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
    
    func postCommunityPostScrapToggle(postId: Int) async -> Result<CommunityScrapStatus, NetworkError> {
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let urlBuilder = URLRequestBuilder(
            url: networkService.appConfiguration.apiBaseURL + networkService.postCommunityPostScrapToggle(postId),
            method: .post
        )
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: CommunityScrapStatus = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
    
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
