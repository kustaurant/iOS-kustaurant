//
//  MyPageFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies {
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController
    func makeProfileComposeViewController(actions: ProfileComposeViewModelActions, profileImgUrl: String?) -> ProfileComposeViewController
    func makeSavedRestaurantsViewController(actions: SavedRestaurantsViewModelActions) -> SavedRestaurantsViewController
    func makeFeedbackSubmittingViewController(actions: FeedbackSubmittingViewModelActions) -> FeedbackSubmittingViewController
    func makeTermsOfServiceViewController(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) -> TermsOfServiceViewController
    func makePrivacyPolicyViewController(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) -> PrivacyPolicyViewController
    func makeNoticeBoardViewController(actions: NoticeBoardViewModelActions) -> NoticeBoardViewController
}

final class MyPageFlowCoordinator: Coordinator {
    private let dependencies: MyPageFlowCoordinatorDependencies
    private let appDIContainer: AppDIContainer
    var navigationController: UINavigationController
    var rootNavigationController: UINavigationController
    weak var appFlowNavigating: AppFlowCoordinatorNavigating?
    
    init(
        dependencies: MyPageFlowCoordinatorDependencies,
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController,
        rootNavigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
        self.rootNavigationController = rootNavigationController
    }
}

extension MyPageFlowCoordinator {
    func start() {
        let actions = MyPageViewModelActions(
            showOnboarding: showOnboarding,
            showProfileCompose: showProfileCompose,
            showSavedRestaurants: showSavedRestaurants,
            showFeedbackSubmitting: showFeedbackSubmitting,
            showNotice: showNoticeBoard,
            showTermsOfService: showTermsOfService,
            showPrivacyPolicy: showPrivacyPolicy
        )
        let viewController = dependencies.makeMyPageViewController(actions: actions)
        let image = UIImage(named: TabBarPage.mypage.pageImageName() + "_off")?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: TabBarPage.mypage.pageImageName() + "_on")?.withRenderingMode(.alwaysOriginal)
        
        viewController.tabBarItem = UITabBarItem(
            title: TabBarPage.mypage.pageTitleValue(),
            image: image,
            selectedImage: selectedImage
        )
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showOnboarding() {
        appFlowNavigating?.showOnboarding()
    }
    
    private func showProfileCompose(_ profileImgUrl: String?) {
        let actions = ProfileComposeViewModelActions(pop: popAnimated)
        let viewController = dependencies.makeProfileComposeViewController(actions: actions, profileImgUrl: profileImgUrl)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showSavedRestaurants() {
        let actions = SavedRestaurantsViewModelActions(
            pop: popAnimated,
            showRestaurantDetail: showRestaurantDetail
        )
        let viewController = dependencies.makeSavedRestaurantsViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showFeedbackSubmitting() {
        let actions = FeedbackSubmittingViewModelActions(
            pop: popAnimated
        )
        let viewController = dependencies.makeFeedbackSubmittingViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showNoticeBoard() {
        let actions = NoticeBoardViewModelActions(
            pop: popAnimated
        )
        let viewController = dependencies.makeNoticeBoardViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showTermsOfService() {
        let actions = PlainWebViewLoadViewModelActions(
            pop: popAnimated
        )
        let termsOfServiceUrl = "https://kustaurant.com/terms_of_use"
        let viewController = dependencies.makeTermsOfServiceViewController(webViewUrl: termsOfServiceUrl, actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPrivacyPolicy() {
        let actions = PlainWebViewLoadViewModelActions(
            pop: popAnimated
        )
        let privacyPolicyUrl = "https://kustaurant.com/privacy-policy"
        let viewController = dependencies.makePrivacyPolicyViewController(webViewUrl: privacyPolicyUrl, actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showRestaurantDetail(restaurantId: Int) {
        let restaurantDetailSceneDIContainer = appDIContainer.makeRestaurantDetailSceneDIContainer()
        let flow = restaurantDetailSceneDIContainer.makeRestaurantDetailFlowCoordinator(
            navigationController: rootNavigationController
        )
        flow.start(id: restaurantId)
    }
    
    private func popAnimated() {
        pop(animated: true)
    }
}
