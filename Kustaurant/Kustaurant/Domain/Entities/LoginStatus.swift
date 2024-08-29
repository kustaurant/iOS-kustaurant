//
//  LoginStatus.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit

enum LoginStatus {
    case loggedIn, notLoggedIn
    
    func toggle() -> LoginStatus {
        switch self {
        case .loggedIn:
            LoginStatus.notLoggedIn
        case .notLoggedIn:
            LoginStatus.loggedIn
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .loggedIn:
                .Sementic.gray800 ?? .black
        case .notLoggedIn:
                .Sementic.gray600 ?? .gray
        }
    }
    
    var iconNamePostfix: String {
        switch self {
        case .loggedIn:
            "_enabled"
        case .notLoggedIn:
            "_disabled"
        }
    }
    
    var profileImageName: String {
        switch self {
        case .loggedIn:
            "img_babycow"
        case .notLoggedIn:
            "icon_person"
        }
    }
    
    var profileButtonConfiguration: UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 6
        configuration.imagePlacement = .trailing
        
        switch self {
        case .loggedIn:
            configuration.image = UIImage(named: "icon_pencil")
        case .notLoggedIn:
            configuration.image = UIImage(named: "icon_chevron_right_white")
        }
        
        return configuration
    }
}
