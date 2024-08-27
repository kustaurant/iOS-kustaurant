//
//  UserRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation

protocol SocialLoginUserRepository {
    func getUser() -> UserCredentials?
    func setUser(_ user: UserCredentials?)
    func removeUser()
}
