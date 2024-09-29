//
//  MyPageUseCases.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

protocol MyPageUseCases {
    func getUserProfile() async -> Result<UserProfile, NetworkError>
    func sendFeedback(_ comments: String) async -> Result<Void, NetworkError>
    func updateUserPrfile(_ userProfile: UserProfile) async -> Result<Void, NetworkError>
    func getSavedRestaurantsCount() async -> Result<UserSavedRestaurantsCount, NetworkError>
    func getFavoriteRestaurants() async -> Result<[FavoriteRestaurant], NetworkError>
    func getEvaluatedRestaurants() async -> Result<[EvaluatedRestaurant], NetworkError>
    func getNoticeList() async -> Result<[Notice], NetworkError> 
    func isLogin() -> Bool
}

final class DefaultMyPageUseCases {
    
    private let myPageRepository: MyPageRepository
    
    init(myPageRepository: MyPageRepository) {
        self.myPageRepository = myPageRepository
    }
}
    
extension DefaultMyPageUseCases: MyPageUseCases {
    func isLogin() -> Bool {
        guard let _: UserCredentials = KeychainStorage.shared.getValue(forKey: KeychainKey.userCredentials) else {
            return false
        }
        return true
    }
    func sendFeedback(_ comments: String) async -> Result<Void, NetworkError> {
        return await myPageRepository.sendFeedback(comments)
    }
    
    func updateUserPrfile(_ userProfile: UserProfile) async -> Result<Void, NetworkError> {
        return await myPageRepository.updateUserPrfile(userProfile)
    }
    
    func getSavedRestaurantsCount() async -> Result<UserSavedRestaurantsCount, NetworkError> {
        return await myPageRepository.fetchSavedRestaurantsCount()
    }
    
    func getFavoriteRestaurants() async -> Result<[FavoriteRestaurant], NetworkError> {
        return await myPageRepository.fetchFavoriteRestaurants()
    }
    
    func getEvaluatedRestaurants() async -> Result<[EvaluatedRestaurant], NetworkError> {
        return await myPageRepository.fetchEvaluatedRestaurants()
    }
    
    func getUserProfile() async -> Result<UserProfile, NetworkError> {
        return await myPageRepository.fetchUserProfile()
    }
    
    func getNoticeList() async -> Result<[Notice], NetworkError> {
        return await myPageRepository.fetchNoticeList()
    }
}
