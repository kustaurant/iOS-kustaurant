//
//  MyPageFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies {
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController
    func makeProfileComposeViewController(actions: ProfileComposeViewModelActions) -> ProfileComposeViewController
    func makeSavedRestaurantsViewController(actions: SavedRestaurantsViewModelActions) -> SavedRestaurantsViewController
    func makeFeedbackSubmittingViewController(actions: FeedbackSubmittingViewModelActions) -> FeedbackSubmittingViewController
    func makeNoticeBoardViewController(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) -> NoticeBoardViewController
    func makeTermsOfServiceViewController(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) -> TermsOfServiceViewController
}

final class MyPageFlowCoordinator: Coordinator {
    private let dependencies: MyPageFlowCoordinatorDependencies
    var navigationController: UINavigationController
    weak var appFlowNavigating: AppFlowCoordinatorNavigating?
    
    init(
        dependencies: MyPageFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
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
            showTermsOfService: showTermsOfService
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
    
    private func showProfileCompose() {
        let actions = ProfileComposeViewModelActions(pop: popAnimated)
        let viewController = dependencies.makeProfileComposeViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showSavedRestaurants() {
        let actions = SavedRestaurantsViewModelActions(
            pop: popAnimated
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
        let actions = PlainWebViewLoadViewModelActions(
            pop: popAnimated
        )
        let noticeBoardUrl = "https://kustaurant.com/notice"
        let viewController = dependencies.makeNoticeBoardViewController(webViewUrl: noticeBoardUrl, actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showTermsOfService() {
        let actions = PlainWebViewLoadViewModelActions(
            pop: popAnimated
        )
        let noticeBoardUrl = "https://kustaurant.com/terms_of_use"
        let viewController = dependencies.makeTermsOfServiceViewController(webViewUrl: noticeBoardUrl, actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func popAnimated() {
        pop(animated: true)
    }
}
