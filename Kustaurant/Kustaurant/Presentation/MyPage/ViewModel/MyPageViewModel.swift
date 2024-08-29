//
//  MyPageViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/19/24.
//

import Foundation
import Combine

struct MyPageViewModelActions {
    let showOnboarding: () -> Void
    let showProfileCompose: () -> Void
}

protocol MyPageViewModelInput {
    func didTapLoginAndStartButton()
    func didTapComposeProfileButton()
    func getUserProfile()
}
protocol MyPageViewModelOutput {
    var tableViewSections: [MyPageTableViewSection] { get }
    var isLoggedIn: LoginStatus { get set }
    var isLoggedInPublisher: Published<LoginStatus>.Publisher { get }
    var userSavedRestaurants: UserSavedRestaurantsCount { get }
    var userSavedRestaurantsPublisher: Published<UserSavedRestaurantsCount>.Publisher { get }
}

typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput

final class DefaultMyPageViewModel {
    
    private let actions: MyPageViewModelActions
    private let authUseCases: AuthUseCases
    private let myPageUseCases: MyPageUseCases
    @Published var isLoggedIn: LoginStatus = .notLoggedIn
    var isLoggedInPublisher: Published<LoginStatus>.Publisher { $isLoggedIn }
    @Published var userSavedRestaurants: UserSavedRestaurantsCount = UserSavedRestaurantsCount.empty()
    var userSavedRestaurantsPublisher: Published<UserSavedRestaurantsCount>.Publisher { $userSavedRestaurants }
    
    var tableViewSections: [MyPageTableViewSection] = [
        MyPageTableViewSection(
            id: "activity",
            items: [
                MyPageTableViewItem(title: "저장된 맛집", iconNamePrefix: "icon_saved_restaurants")
            ],
            footerHeight: 20
        ),
        MyPageTableViewSection(
            id: "service",
            items: [
                MyPageTableViewItem(title: "이용약관", iconNamePrefix: "icon_terms_of_service"),
                MyPageTableViewItem(title: "의견 보내기", iconNamePrefix: "icon_send_feedback"),
                MyPageTableViewItem(title: "공지사항", iconNamePrefix: "icon_notice_board"),
                MyPageTableViewItem(title: "개인정보처리방침", iconNamePrefix: "icon_privacy_policy")
            ],
            footerHeight: 20
        ),
        MyPageTableViewSection(
            id: "user",
            items: [
                MyPageTableViewItem(title: "로그아웃", iconNamePrefix: "icon_logout"),
                MyPageTableViewItem(title: "회원탈퇴", iconNamePrefix: "icon_delete_account")
            ],
            footerHeight: 100
        )
    ]
    
    init(actions: MyPageViewModelActions, authUseCases: AuthUseCases, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.authUseCases = authUseCases
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultMyPageViewModel {
    
    func getUserProfile() {
        Task {
            let userSavedRestaurants = await myPageUseCases.getSavedRestaurantsCount()
            switch userSavedRestaurants {
            case .success(let savedRestaurants):
                isLoggedIn = .loggedIn
                self.userSavedRestaurants = savedRestaurants
            case .failure(let failure):
                isLoggedIn = .notLoggedIn
            }
        }
    }
}

// Button Actions
extension DefaultMyPageViewModel: MyPageViewModel {
    
    func didTapLoginAndStartButton() {
        authUseCases.logout()
        actions.showOnboarding()
    }
    
    func didTapComposeProfileButton() {
        actions.showProfileCompose()
    }
}
