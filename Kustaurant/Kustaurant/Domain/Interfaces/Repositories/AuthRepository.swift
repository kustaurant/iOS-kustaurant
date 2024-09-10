//
//  AuthRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/19/24.
//

import Foundation

protocol AuthRepository {
    func naverLogin(userId: String, naverAccessToken: String) async -> Result<String, NetworkError>
    func appleLogin(authorizationCode: String, identityToken: String) async -> Result<String, NetworkError>
    func logout(userId: String) async
    func deleteAccount() async
    func verifyToken() async -> Bool 
}
