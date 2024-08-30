//
//  NoticeBoardViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import Foundation

struct NoticeBoardViewModelActions {
    let pop: () -> Void
}

protocol NoticeBoardViewModelInput {
    func didTapBackButton()
}
protocol NoticeBoardViewModelOutput {
    var noticeBoardUrl: String { get }
}

typealias NoticeBoardViewModel = NoticeBoardViewModelInput & NoticeBoardViewModelOutput

final class DefaultNoticeBoardViewModel: NoticeBoardViewModel {
    
    var noticeBoardUrl: String = "https://kustaurant.com/notice"
    
    private let actions: NoticeBoardViewModelActions
    private let myPageUseCases: MyPageUseCases
    
    init(actions: NoticeBoardViewModelActions, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultNoticeBoardViewModel {
    
    func didTapBackButton() {
        actions.pop()
    }
}
