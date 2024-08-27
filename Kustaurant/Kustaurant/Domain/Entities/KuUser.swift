//
//  SocialLoginUser.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/17/24.
//

import Foundation

enum SocialLoginProvider: String, Codable {
    case naver, apple
}

struct KuUser: Codable {
    let id: String
    let accessToken: String
    let provider: SocialLoginProvider
}

