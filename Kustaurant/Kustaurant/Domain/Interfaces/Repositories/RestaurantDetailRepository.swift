//
//  RestaurantDetailRepository.swift
//  Kustaurant
//
//  Created by 류연수 on 8/13/24.
//

import Foundation

protocol RestaurantDetailRepository {
    
    func fetch() async -> RestaurantDetail
    func fetchReviews() async -> [RestaurantDetailCellItem]
}

final class DefaultRestaurantDetailRepository: RestaurantDetailRepository {
    
    private let networkService: NetworkService
    private let restaurantID: Int
    
    init(networkService: NetworkService, restaurantID: Int) {
        self.networkService = networkService
        self.restaurantID = restaurantID
    }
    
    func fetch() async -> RestaurantDetail {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/restaurants/\(restaurantID)")
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response: RestaurantDetailDTO? = await request.responseAsync(with: urlBuilder).decode()
        
        let items = viewDatas(from: response)
        let tabItems: RestaurantDetail.TabItems = [.menu: items[.tab] ?? [], .review: []]
        
        return .init(restaurantImageURLString: response?.restaurantImageURLString ?? "", items: items, tabItems: tabItems)
        
    }
    
    private func viewDatas(from response: RestaurantDetailDTO?) -> RestaurantDetail.Items {
        guard let response else { return [:] }
        
        let null = "NULL"
        let titleInfo: RestaurantDetailTitle = .init(
            cuisineType: response.restaurantCuisine ?? null,
            title: response.restaurantName ?? null,
            isReviewCompleted: response.isEvaluated ?? false,
            address: response.restaurantAddress ?? null,
            openingHours: response.businessHours ?? null,
            mapURL: .init(string: response.naverMapURLString ?? null)
        )
        let tierInfos: [RestaurantDetailTierInfo] = [.init(
            iconImageName: response.mainTier?.iconImageName,
            title: "\(response.restaurantCuisine ?? null) \(response.mainTier?.rawValue ?? 0)티어",
            backgroundColor: response.mainTier?.backgroundColor()
        )] + (response.situationList?.compactMap { title in
            return .init(iconImageName: nil, title: title, backgroundColor: .green100)
        } ?? [])
        let affiliateInfo: RestaurantDetailAffiliateInfo = .init(text: response.partnershipInfo ?? null)
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
    
    func fetchReviews() async -> [RestaurantDetailCellItem] {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/restaurants/\(restaurantID)/comments")
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
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
                dislikeCount: comment.commentDislikeCount ?? 0
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
                    dislikeCount: reply.commentDislikeCount ?? 0
                )
            } ?? [])
        } ?? []).flatMap { $0 }
        
        return reviews
    }
}
