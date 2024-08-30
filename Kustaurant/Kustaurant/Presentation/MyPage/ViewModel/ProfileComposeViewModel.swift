//
//  ProfileComposeViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import Foundation

struct ProfileComposeViewModelActions {
    let pop: () -> Void
}

protocol ProfileComposeViewModelInput {}
protocol ProfileComposeViewModelOutput {}

typealias ProfileComposeViewModel = ProfileComposeViewModelInput & ProfileComposeViewModelOutput

final class DefaultProfileComposeViewModel: ProfileComposeViewModel {
    
    private let actions: ProfileComposeViewModelActions
    
    init(actions: ProfileComposeViewModelActions) {
        self.actions = actions
    }
}
