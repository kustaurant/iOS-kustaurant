//
//  MyPageViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/19/24.
//

import Foundation

struct MyPageViewModelActions {
    let showOnboarding: () -> Void
}

protocol MyPageViewModelInput {
}
protocol MyPageViewModelOutput {
    var tableViewSections: [MyPageTableViewSection] { get }
}

typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput

final class DefaultMyPageViewModel {
    
    private let actions: MyPageViewModelActions
    private let authUseCases: AuthUseCases
    private let myPageUseCases: MyPageUseCases
    
    var tableViewSections: [MyPageTableViewSection] = [
        MyPageTableViewSection(
            id: "activity",
            items: [
                MyPageTableViewItem(title: "저장된 맛집", iconNamePostfix: "icon_saved_restaurants")
            ],
            footerHeight: 20
        ),
        MyPageTableViewSection(
            id: "service",
            items: [
                MyPageTableViewItem(title: "이용약관", iconNamePostfix: "icon_terms_of_service"),
                MyPageTableViewItem(title: "의견 보내기", iconNamePostfix: "icon_send_feedback"),
                MyPageTableViewItem(title: "공지사항", iconNamePostfix: "icon_notice_board"),
                MyPageTableViewItem(title: "개인정보처리방침", iconNamePostfix: "icon_privacy_policy")
            ],
            footerHeight: 20
        ),
        MyPageTableViewSection(
            id: "user",
            items: [
                MyPageTableViewItem(title: "로그아웃", iconNamePostfix: "icon_logout"),
                MyPageTableViewItem(title: "회원탈퇴", iconNamePostfix: "icon_delete_account")
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

extension DefaultMyPageViewModel: MyPageViewModel {
}
