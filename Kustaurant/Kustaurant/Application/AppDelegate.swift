//
//  AppDelegate.swift
//  Kustaurant
//
//  Created by 송우진 on 7/7/24.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        NaverLoginService.configureAppDelegate()
        return true
    }
}

