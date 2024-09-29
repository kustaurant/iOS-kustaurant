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
    let showProfileCompose: (_ profileImgUrl: String?) -> Void
    let showSavedRestaurants: () -> Void
    let showFeedbackSubmitting: () -> Void
    let showNotice:() -> Void
    let showTermsOfService: () -> Void
    let showPrivacyPolicy: () -> Void
    let showEvaluatedRestaurants: () -> Void
}

protocol MyPageViewModelInput {
    func didTapLoginAndStartButton()
    func didTapComposeProfileButton()
    func didTapSavedRestaurants()
    func didTapEvaluatedRestaurants()
    func getUserSavedRestaurants()
    func didTapSendFeedback()
    func didTapNotice()
    func didTapTermsOfService()
    func didTapPrivacyPolicy()
    func didTapLogoutButton()
    func didTapDeleteAccount()
    func dismissAlert()
}

protocol MyPageViewModelOutput {
    var tableViewSections: [MyPageTableViewSection] { get }
    var isLoggedIn: LoginStatus { get set }
    var isLoggedInPublisher: Published<LoginStatus>.Publisher { get }
    var userSavedRestaurants: UserSavedRestaurantsCount { get }
    var userSavedRestaurantsPublisher: Published<UserSavedRestaurantsCount>.Publisher { get }
    var showAlert: Bool { get }
    var showAlertPublisher: Published<Bool>.Publisher { get }
    var alertPayload: AlertPayload { get }
    var tableViewSectionsPublisher: Published<[MyPageTableViewSection]>.Publisher { get }
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
    @Published var showAlert: Bool = false
    var showAlertPublisher: Published<Bool>.Publisher { $showAlert }
    @Published var alertPayload: AlertPayload = AlertPayload.empty()
    @Published var tableViewSections: [MyPageTableViewSection] = []
    var tableViewSectionsPublisher: Published<[MyPageTableViewSection]>.Publisher { $tableViewSections }
    
    init(actions: MyPageViewModelActions, authUseCases: AuthUseCases, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.authUseCases = authUseCases
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultMyPageViewModel {
    
    func isLogin() -> Bool {
        myPageUseCases.isLogin()
    }
    func updateTableViewSections(isLoggedIn: LoginStatus) {
        var sections: [MyPageTableViewSection] = [
            MyPageTableViewSection(
                id: "service",
                items: [
                    MyPageTableViewItem(type: .termsOfService, title: "이용약관", iconNamePrefix: "icon_terms_of_service"),
                    MyPageTableViewItem(type: .notice, title: "공지사항", iconNamePrefix: "icon_notice_board"),
                    MyPageTableViewItem(type: .privacyPolicy, title: "개인정보처리방침", iconNamePrefix: "icon_privacy_policy")
                ],
                footerHeight: 20
            )
        ]
        
        if isLoggedIn == .loggedIn {
            sections.insert(
                MyPageTableViewSection(
                    id: "activity",
                    items: [
                        MyPageTableViewItem(type: .savedRestaurants, title: "저장된 맛집", iconNamePrefix: "icon_saved_restaurants")
                    ],
                    footerHeight: 20
                ), at: 0)
            sections[1].items.append(MyPageTableViewItem(type: .sendFeedback, title: "의견 보내기", iconNamePrefix: "icon_send_feedback"))
            sections.append(
                MyPageTableViewSection(
                    id: "user",
                    items: [
                        MyPageTableViewItem(type: .logout, title: "로그아웃", iconNamePrefix: "icon_logout"),
                        MyPageTableViewItem(type: .deleteAccount, title: "회원탈퇴", iconNamePrefix: "icon_delete_account")
                    ],
                    footerHeight: 100
                )
            )
        }
        
        tableViewSections = sections
        self.isLoggedIn = isLoggedIn
    }
    
    func getUserSavedRestaurants() {
        guard isLogin() == true else {
            updateTableViewSections(isLoggedIn: .notLoggedIn)
            return
        }
        Task {
            let userSavedRestaurants = await myPageUseCases.getSavedRestaurantsCount()
            switch userSavedRestaurants {
            case .success(let savedRestaurants):
                updateTableViewSections(isLoggedIn: .loggedIn)
                self.userSavedRestaurants = savedRestaurants
                
                
            case .failure:
                updateTableViewSections(isLoggedIn: .notLoggedIn)
            }
        }
    }
    
    func logout() {
        dismissAlert()
        authUseCases.logout()
        actions.showOnboarding()
    }
    
    func deleteAccount() {
        Task {
            await authUseCases.deleteAccount()
            await MainActor.run {
                dismissAlert()
                actions.showOnboarding()
            }
        }
    }
    
    private func showAlertLogin() {
        alertPayload = AlertPayload(title: "로그인 후 사용 가능합니다.", subtitle: "로그인 하시겠습니까?", onConfirm: didTapLoginAndStartButton)
        showAlert = true
    }
}

// Button Actions
extension DefaultMyPageViewModel: MyPageViewModel {
    
    func dismissAlert() {
        showAlert = false
        alertPayload = AlertPayload.empty()
    }
    
    func didTapDeleteAccount() {
        alertPayload = AlertPayload(title: "회원탈퇴 하시겠습니까?", subtitle: "작성한 글, 평가는 삭제되지 않지만 개인정보는 안전하게 삭제됩니다.", onConfirm: deleteAccount)
        showAlert = true
    }
    
    func didTapLogoutButton() {
        alertPayload = AlertPayload(title: "로그아웃 하시겠습니까?", subtitle: "", onConfirm: logout)
        showAlert = true
    }
    
    func didTapLoginAndStartButton() {
        authUseCases.logout()
        actions.showOnboarding()
    }
    
    func didTapComposeProfileButton() {
        actions.showProfileCompose(userSavedRestaurants.iconImgUrl)
    }
    
    func didTapSavedRestaurants() {
        guard isLogin() == true else {
            showAlertLogin()
            return
        }
        actions.showSavedRestaurants()
    }
    
    func didTapEvaluatedRestaurants() {
        guard isLogin() == true else {
            showAlertLogin()
            return
        }
        actions.showEvaluatedRestaurants()
    }
    
    func didTapSendFeedback() {
        actions.showFeedbackSubmitting()
    }
    
    func didTapNotice() {
        actions.showNotice()
    }
    
    func didTapTermsOfService() {
        actions.showTermsOfService()
    }
    
    func didTapPrivacyPolicy() {
        actions.showPrivacyPolicy()
    }
}
