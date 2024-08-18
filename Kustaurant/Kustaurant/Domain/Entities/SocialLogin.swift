//
//  SocialLoginUser.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/17/24.
//

import Foundation

enum SocialLoginProvider: Codable {
    case naver, apple
}

struct SocialLoginUser: Codable {
    let id: String
    let accessToken: String
    let provider: SocialLoginProvider
}

struct NaverMeResponse: Codable {
    let resultcode: String
    let response: Response
    
    struct Response: Codable {
        let id: String
    }
}
