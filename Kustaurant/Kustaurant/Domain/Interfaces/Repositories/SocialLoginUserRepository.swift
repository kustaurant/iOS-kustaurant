//
//  UserRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation

protocol SocialLoginUserRepository {
    func getUser() -> KuUser?
    func setUser(_ user: KuUser?)
    func removeUser()
}
