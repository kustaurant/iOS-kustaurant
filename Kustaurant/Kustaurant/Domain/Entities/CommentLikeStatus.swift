//
//  CommentLikeStatus.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/4/24.
//

import UIKit

enum CommentLikeStatus: Int, Codable {
    case liked = 1
    case disliked = -1
    case none = 0
    
    var thumbsUpIconImageName: String {
        switch self {
        case .liked:
            return "icon_thumbs_up_activated"
        default:
            return "icon_thumbs_up_deactivated"
        }
    }
    
    var thumbsDownIconImageName: String {
        switch self {
        case .disliked:
            return "icon_thumbs_down_activated"
        default:
            return "icon_thumbs_down_deactivated"
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .liked:
            return UIColor.Signature.green100 ?? .systemGreen
        default:
            return UIColor.Sementic.gray300 ?? .lightGray
        }
    }
}
