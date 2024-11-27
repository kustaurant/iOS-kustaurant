//
//  NaverMeResponse.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/21/24.
//

import Foundation

struct NaverMeResponse: Codable {
    let resultcode: String
    let response: Response
    
    struct Response: Codable {
        let id: String
    }
}
