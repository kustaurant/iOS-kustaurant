//
//  NaverMapExternalLinkService.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/4/24.
//

import UIKit

final class NaverMapExternalLinkService {
    
    private init() {}
    
    static func openNaverMapOrAppStore(with placeId: Int) {
        var appName = Bundle.main.bundleIdentifier ?? "kustrauant.Kustaurant"
        let urlString = "nmap://place?id=\(placeId)&appname=\(appName)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodedStr) else { return }
        guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
}
