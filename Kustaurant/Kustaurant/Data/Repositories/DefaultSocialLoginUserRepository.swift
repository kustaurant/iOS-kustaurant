//
//  DefaultSocialLoginUserRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation

final class DefaultSocialLoginUserRepository {
    
    private let keychainStorage: KeychainStorage
    
    init(keychainStorage: KeychainStorage) {
        self.keychainStorage = keychainStorage
    }
}

extension DefaultSocialLoginUserRepository: SocialLoginUserRepository {
    func getUser() -> KuUser? {
        let user: KuUser? = keychainStorage.getValue(forKey: KeychainKey.socialLoginUser)
        return user
    }
    
    func setUser(_ user: KuUser? = nil) {
        _ = keychainStorage.setValue(user, forKey: KeychainKey.socialLoginUser)
    }
}
