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
    
    func makeDrawSceneDIContainer() -> DrawSceneDIContainer {
        let dependencies = DrawSceneDIContainer.Dependencies(
            networkService: networkService
        )
        return DrawSceneDIContainer(dependencies: dependencies)
    }
    
    func makeTierSceneDIContainer() -> TierSceneDIContainer {
        let dependecies = TierSceneDIContainer.Dependencies(
            networkService: networkService
        )
        return TierSceneDIContainer(
            dependencies: dependecies
        )
    }
    
    func makeCommunitySceneDIContainer() -> CommunitySceneDIContainer {
        let dependecies = CommunitySceneDIContainer.Dependencies(
            networkService: networkService
        )
        return CommunitySceneDIContainer(
            dependencies: dependecies
        )
    }
    
    func makeMyPageSceneDIContainer() -> MyPageSceneDIContainer {
        let dependencies = MyPageSceneDIContainer.Dependencies(networkService: networkService)
        return MyPageSceneDIContainer(dependencies: dependencies)
    }
    
    func makeRestaurantDetailSceneDIContainer() -> RestaurantDetailSceneDIContainer {
        let dependencies = RestaurantDetailSceneDIContainer.Dependencies(
            appDIContainer: self,
            networkService: networkService
        )
        return RestaurantDetailSceneDIContainer(dependencies: dependencies)
    }
    
    func makeOnboardingDIContainer() -> OnboardingSceneDIContainer {
        let dependencies = OnboardingSceneDIContainer.Dependencies(
            networkService: networkService
        )
        return OnboardingSceneDIContainer(dependencies: dependencies)
    }
    
    func makeSearchDIContainer() -> SearchSceneDIContainer {
        let dependencies = SearchSceneDIContainer.Dependencies(networkService: networkService)
        return SearchSceneDIContainer(dependencies: dependencies)
    }
    
    func makeEvaluationDIContainer() -> EvaluationSceneDIContainer {
        let dependencies = EvaluationSceneDIContainer.Dependencies(networkService: networkService)
        return EvaluationSceneDIContainer(dependencies: dependencies)
    }
}

