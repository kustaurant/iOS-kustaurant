//
//  DefaultSocialLoginUserRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation

final class DefaultSocialLoginUserRepository: SocialLoginUserRepository {
    
    func getUser() -> KuUser? {
        let user: KuUser? = KeychainStorage.shared.getValue(forKey: KeychainKey.kuUser)
        return user
    }
    
    func setUser(_ user: KuUser? = nil) {
        KeychainStorage.shared.setValue(user, forKey: KeychainKey.kuUser)
    }
}
