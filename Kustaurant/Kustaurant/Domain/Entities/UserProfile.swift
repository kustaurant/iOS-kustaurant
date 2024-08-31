//
//  UserProfile.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

struct UserProfile: Codable {
    let nickname: String?
    let email: String?
    let phoneNumber: String?
    
    init(nickname: String, phoneNumber: String) {
        self.nickname = nickname
        self.phoneNumber = phoneNumber
        self.email = nil
    }
    
    static func empty() -> UserProfile {
        UserProfile(nickname: "", phoneNumber: "")
    }
}