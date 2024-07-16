//
//  AppDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import Foundation

/// 앱의 전체적인 의존성 주입을 관리하는 Container입니다.
final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        HomeSceneDIContainer()
    }
    
    func makeRecommendSceneDIContainer() -> RecommendSceneDIContainer {
        RecommendSceneDIContainer()
    }
    
    func makeTierSceneDIContainer() -> TierSceneDIContainer {
        TierSceneDIContainer()
    }
}

