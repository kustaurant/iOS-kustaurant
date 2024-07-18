//
//  AppDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import Foundation

/// 앱의 전체적인 의존성 주입을 관리하는 Container입니다.
final class AppDIContainer {
    lazy var networkService = NetworkService()
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        let dependecies = HomeSceneDIContainer.Dependencies(
            networkService: networkService
        )
        return HomeSceneDIContainer(
            dependencies: dependecies
        )
    }
    
    func makeRecommendSceneDIContainer() -> RecommendSceneDIContainer {
        RecommendSceneDIContainer()
    }
    
    func makeTierSceneDIContainer() -> TierSceneDIContainer {
        TierSceneDIContainer()
    }
    
    func makeCommunitySceneDIContainer() -> CommunitySceneDIContainer {
        CommunitySceneDIContainer()
    }
    
    func makeMyPageSceneDIContainer() -> MyPageSceneDIContainer {
        MyPageSceneDIContainer()
    }
}

