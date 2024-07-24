//
//  Location.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

enum Location: String, CaseIterable, CategoryProtocol {
    case all = "전체"
    case l1 = "건입~중문"
    case l2 = "중문~어대"
    case l3 = "후문"
    case l4 = "정문"
    case l5 = "구의역"
    
    var displayName: String {
        rawValue
    }
    
    var code: String {
        String(describing: self).uppercased()
    }
}
