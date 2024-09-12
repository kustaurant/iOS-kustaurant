//
//  DefaultRestaurantDetailRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/4/24.
//

import Foundation

final class DefaultRestaurantDetailRepository: RestaurantDetailRepository {
    
    private let networkService: NetworkService
    let restaurantID: Int
    
    init(networkService: NetworkService, restaurantID: Int) {
        self.networkService = networkService
        self.restaurantID = restaurantID
    }
    
    func fetch() async -> RestaurantDetail {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/restaurants/\(restaurantID)")
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response: RestaurantDetailDTO? = await request.responseAsync(with: urlBuilder).decode()
        
        let items = viewDatas(from: response)
        let tabItems: RestaurantDetail.TabItems = [.menu: items[.tab] ?? [], .review: []]
        
        return .init(
            evaluationCount: response?.evaluationCount ?? 0,
            isFavorite: response?.isFavorite ?? false,
            restaurantImageURLString: response?.restaurantImageURLString ?? "",
            items: items,
            tabItems: tabItems
        )
    }
    
    private func viewDatas(from response: RestaurantDetailDTO?) -> RestaurantDetail.Items {
        guard let response else { return [:] }
        
        let null = "NULL"
        let tierTitle: String
        if let cuisine = response.restaurantCuisine,
           let tier = response.mainTier?.rawValue,
           tier != -1
        {
            tierTitle = "\(cuisine) \(tier)티어"
        } else {
            tierTitle = response.restaurantCuisine ?? ""
        }
        
        let titleInfo: RestaurantDetailTitle = .init(
            cuisineType: response.restaurantCuisine ?? null,
            title: response.restaurantName ?? null,
            isReviewCompleted: response.isEvaluated ?? false,
            address: response.restaurantAddress ?? null,
            openingHours: response.businessHours ?? null,
            mapURL: .init(string: response.naverMapURLString ?? null),
            restaurantPosition: response.restaurantPosition ?? "",
            tier: response.mainTier,
            isFavorite: response.isFavorite ?? false
        )
        let tierInfos: [RestaurantDetailTierInfo] = [.init(
            restaurantCuisine: response.restaurantCuisine,
            title: tierTitle,
            backgroundColor: response.mainTier?.backgroundColor()
        )] + (response.situationList?.compactMap { title in
            return .init(restaurantCuisine: nil, title: title, backgroundColor: .green100)
        } ?? [])
        let affiliateInfo: RestaurantDetailAffiliateInfo = .init(text: response.partnershipInfo ?? "제휴정보 없음")
        let ratingInfo: RestaurantDetailRating = .init(count: response.evaluationCount ?? 0, score: response.restaurantScore)
        let menuInfos: [RestaurantDetailMenu] = response.restaurantMenuList?.compactMap ({ menu in
                .init(imageURLString: menu.menuImgUrl ?? null, title: menu.menuName ?? null, price: menu.menuPrice ?? null)
        }) ?? []
        
        let items: RestaurantDetail.Items = [
            .title: [titleInfo],
            .tier: [RestaurantDetailTiers(tiers: tierInfos)],
            .affiliate: [affiliateInfo],
            .rating: [ratingInfo],
            .tab: menuInfos
        ]
        
        return items
    }
    
    func fetchReviews(sort: ReviewSort) async -> [RestaurantDetailCellItem] {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/restaurants/\(restaurantID)/comments")
        urlBuilder.addQuery(parameter: ["sort": sort.rawValue])
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response: [RestaurantCommentDTO]? = await request.responseAsync(with: urlBuilder).decode()
        
        let null = "NULL"
        
        let reviews: [RestaurantDetailReview] = (response?.compactMap { comment in
            [RestaurantDetailReview(
                profileImageURLString: comment.commentIconImageURLString ?? null,
                nickname: comment.commentNickname ?? null,
                time: comment.commentTime ?? null,
                photoImageURLString: comment.commentImageURLString ?? null,
                review: comment.commentBody ?? null,
                rating: comment.commentScore,
                isComment: false,
                hasComments: !(comment.commentReplies?.isEmpty ?? true),
                likeCount: comment.commentLikeCount ?? 0,
                dislikeCount: comment.commentDislikeCount ?? 0,
                likeStatus: comment.commentLikeStatus ?? .none,
                commentId: comment.commentID ?? -1,
                isCommentMine: comment.isCommentMine ?? false,
                commentChildrenCount: comment.commentReplies?.count ?? 0
            )] + (comment.commentReplies?.enumerated().map { index, reply in
                RestaurantDetailReview(
                    profileImageURLString: reply.commentIconImageURLString ?? null,
                    nickname: reply.commentNickname ?? null,
                    time: reply.commentTime ?? null,
                    photoImageURLString: reply.commentImageURLString ?? null,
                    review: reply.commentBody ?? null,
                    rating: nil,
                    isComment: true,
                    hasComments: index < (comment.commentReplies?.count ?? 0) - 1,
                    likeCount: reply.commentLikeCount ?? 0,
                    dislikeCount: reply.commentDislikeCount ?? 0,
                    likeStatus: reply.commentLikeStatus ?? .none,
                    commentId: reply.commentID ?? -1,
                    isCommentMine: reply.isCommentMine ?? false,
                    commentChildrenCount: 0
                )
            } ?? [])
        } ?? []).flatMap { $0 }
        
        return reviews
    }
    
    func likeComment(restaurantId: Int, commentId: Int) async -> Result<RestaurantCommentDTO, NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantId)/comments/\(commentId)/like", method: .post)
        let authInterceptor = AuthorizationInterceptor()
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: RestaurantCommentDTO = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
    
    func dislikeComment(restaurantId: Int, commentId: Int) async -> Result<RestaurantCommentDTO, NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantId)/comments/\(commentId)/dislike", method: .post)
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: RestaurantCommentDTO = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
    
    func reportComment(restaurantId: Int, commentId: Int) async -> Bool {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantId)/comments/\(commentId)/report", method: .post)
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            Logger.error(error.localizedDescription, category: .network)
            return false
        }
        
        return true
    }
    
    func deleteComment(restaurantId: Int, commentId: Int) async -> Bool {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantId)/comments/\(commentId)", method: .delete)
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            Logger.error(error.localizedDescription, category: .network)
            return false
        }
        
        return true
    }
    
    func addComment(restaurantId: Int, commentId: Int, comment: String) async -> Result<RestaurantDetailReview, NetworkError> {
        let null = "NULL"
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantId)/comments/\(commentId)", method: .post)
        let authInterceptor = AuthorizationInterceptor()
        urlBuilder.addContentType(.textPlain)
        let body = comment.data(using: .utf8)
        urlBuilder.setBody(body)
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            Logger.error(error.localizedDescription, category: .network)
            return .failure(error)
        }
        
        guard let data: RestaurantCommentDTO = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        let review = RestaurantDetailReview(
            profileImageURLString: data.commentIconImageURLString ?? null,
            nickname: data.commentNickname ?? null,
            time: data.commentTime ?? null,
            photoImageURLString: data.commentImageURLString ?? null,
            review: data.commentBody ?? null,
            rating: nil,
            isComment: true,
            hasComments: true,
            likeCount: data.commentLikeCount ?? 0,
            dislikeCount: data.commentDislikeCount ?? 0,
            likeStatus: data.commentLikeStatus ?? .none,
            commentId: data.commentID ?? -1,
            isCommentMine: data.isCommentMine ?? false,
            commentChildrenCount: 0
        )
        
        return .success(review)
    }
    
    func toggleFavorite(restaurantId: Int) async -> Result<Bool, NetworkError> {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantId)/favorite-toggle", method: .post)
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            Logger.error(error.localizedDescription, category: .network)
            return .failure(error)
        }
        
        guard let data: Bool = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
}
