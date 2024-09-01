//
//  DefaultSocialLoginUserRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation

final class DefaultSocialLoginUserRepository: SocialLoginUserRepository {
    
    func getUser() -> UserCredentials? {
        let user: UserCredentials? = KeychainStorage.shared.getValue(forKey: KeychainKey.userCredentials)
        return user
    }
    
    func setUser(_ user: UserCredentials? = nil) {
        KeychainStorage.shared.setValue(user, forKey: KeychainKey.userCredentials)
    }
    
    func removeUser() {
        KeychainStorage.shared.removeValue(forKey: KeychainKey.userCredentials)
    }
}
