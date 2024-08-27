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
    func didTapLogoutButton()
}
protocol MyPageViewModelOutput {}

typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput

final class DefaultMyPageViewModel {
    
    private let actions: MyPageViewModelActions
    private let authUseCases: AuthUseCases
    private let myPageUseCases: MyPageUseCases
    
    init(actions: MyPageViewModelActions, authUseCases: AuthUseCases, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.authUseCases = authUseCases
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultMyPageViewModel: MyPageViewModel {
    
    func didTapLogoutButton() {
        authUseCases.logout()
        actions.showOnboarding()
    }
}
