//
//  AuthRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/19/24.
//

import Foundation

protocol AuthRepository {
    func naverLogin(userId: String, naverAccessToken: String) async -> Result<String, NetworkError>
    func naverLogout(userId: String) async
}
