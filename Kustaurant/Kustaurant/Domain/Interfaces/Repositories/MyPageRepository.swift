//
//  MyPageUseCases.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

protocol MyPageRepository {
    func sendFeedback(_ comments: String) async -> Result<Void, NetworkError>
    func fetchUserProfile() async -> Result<UserProfile, NetworkError>
    func updateUserPrfile(_ userProfile: UserProfile) async -> Result<Void, NetworkError>
    func fetchSavedRestaurantsCount() async -> Result<UserSavedRestaurantsCount, NetworkError>
    func fetchFavoriteRestaurants() async -> Result<[FavoriteRestaurant], NetworkError>
    func fetchEvaluatedRestaurants() async -> Result<[EvaluatedRestaurant], NetworkError>
    func fetchNoticeList() async -> Result<[Notice], NetworkError> 
}
