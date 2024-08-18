//
//  LoginService.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation
import Combine

protocol LoginService {
    func attemptLogin() -> AnyPublisher<SocialLoginUser, NetworkError>
    func attemptLogout()
}
