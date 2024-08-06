//
//  OnboardingViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import Foundation

struct SplashViewModelActions {
    let showLoginPage: () -> Void
    let showTabs: () -> Void
}

final class SplashViewModel {
    
    private let actions: SplashViewModelActions
    
    init(actions: SplashViewModelActions) {
        self.actions = actions
        attempLogin()
    }
    
    /*
     여기서 API를 통해 스플래시 화면에서 로그인 성공 유무를 확인하고
     성공시 -> 탭바
     실패시 -> 로그인 화면(showLoginPage 메소드 호출)
     */
    func attempLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.actions.showTabs()
        }
    }
}
