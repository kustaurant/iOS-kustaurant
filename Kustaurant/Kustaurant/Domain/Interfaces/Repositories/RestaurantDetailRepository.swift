//
//  RestaurantDetailRepository.swift
//  Kustaurant
//
//  Created by 류연수 on 8/13/24.
//

import Foundation

protocol RestaurantDetailRepository {
    associatedtype Sections
    associatedtype Items
    
    func fetch() async -> (Sections, Items)
    func fetchReviews() async -> [RestaurantDetailCellItem]
}

final class DefaultRestaurantDetailRepository: RestaurantDetailRepository {
    typealias Sections = [RestaurantDetailSection: RestaurantDetailHeaderItem]
    typealias Items = [RestaurantDetailSection: [RestaurantDetailCellItem]]
    
    private let networkService: NetworkService
    private let restaurantID: Int
    
    init(networkService: NetworkService, restaurantID: Int) {
        self.networkService = networkService
        self.restaurantID = restaurantID
    }
    
    func fetch() async -> (Sections, Items) {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/restaurants/\(restaurantID)")
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response: RestaurantDetail? = await request.responseAsync(with: urlBuilder).decode()
        
        return viewDatas(from: response)
        
    }
    
    private func viewDatas(from response: RestaurantDetail?) -> (Sections, Items) {
        guard let response else { return ([:], [:]) }
        
        let null = "NULL"
        let titleSection: RestaurantDetailTitle = .init(
            cuisineType: response.restaurantCuisine ?? null,
            title: response.restaurantName ?? null,
            isReviewCompleted: response.isEvaluated ?? false,
            address: response.restaurantAddress ?? null,
            openingHours: response.businessHours ?? null,
            mapURL: .init(string: response.naverMapURLString ?? null)
        )
        let tierInfoSection: RestaurantDetailInfo = .init(title: "티어 정보")
        let affiliateInfoSection: RestaurantDetailInfo = .init(title: "제휴 정보")
        
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
        
        let sections: Sections = [
            .title: titleSection,
            .tier: tierInfoSection,
            .affiliate: affiliateInfoSection
        ]
        
        let items: Items = [
            .tier: [RestaurantDetailTiers(tiers: tierInfos)],
            .affiliate: [affiliateInfo],
            .rating: [ratingInfo],
            .tab: menuInfos
        ]
        
        return (sections, items)
    }
    
    func fetchReviews() async -> [RestaurantDetailCellItem] {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/restaurants/\(restaurantID)/comments")
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response: [RestaurantComment]? = await request.responseAsync(with: urlBuilder).decode()
        
        let null = "NULL"
        
        let reviews: [RestaurantDetailReview] = (response?.compactMap { comment in
            [RestaurantDetailReview(
                profileImageName: comment.commentIconImageURLString ?? null,
                nickname: comment.commentNickname ?? null,
                time: comment.commentTime ?? null,
                photoImageURLString: comment.commentImageURLString ?? null,
                review: comment.commentBody ?? null,
                rating: comment.commentScore,
                isComment: false,
                hasComments: !(comment.commentReplies?.isEmpty ?? true)
            )] + (comment.commentReplies?.enumerated().map { index, reply in
                RestaurantDetailReview(
                    profileImageName: reply.commentIconImageURLString ?? null,
                    nickname: reply.commentNickname ?? null,
                    time: reply.commentTime ?? null,
                    photoImageURLString: reply.commentImageURLString ?? null,
                    review: reply.commentBody ?? null,
                    rating: nil,
                    isComment: true,
                    hasComments: index < (comment.commentReplies?.count ?? 0) - 1
                )
            } ?? [])
        } ?? []).flatMap { $0 }
        
        return reviews
    }
}
