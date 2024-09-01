//
//  NoticeBoardViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/1/24.
//

import Foundation
import Combine

final class ExpandableNotice {
    let notice: Notice
    var isExpanded: Bool = false
    
    init(notice: Notice) {
        self.notice = notice
    }
}

struct NoticeBoardViewModelActions {
    let pop: () -> Void
}

protocol NoticeBoardViewModelInput {
    func didTapBackButton()
    func getNoticeList()
}

protocol NoticeBoardViewModelOutput {
    var noticeList: [ExpandableNotice] { get }
    var noticeListPublisher: Published<[ExpandableNotice]>.Publisher { get }
}

typealias NoticeBoardViewModel = NoticeBoardViewModelInput & NoticeBoardViewModelOutput

final class DefaultNoticeBoardViewModel: NoticeBoardViewModel {
    
    private let actions: NoticeBoardViewModelActions
    private let myPageUseCases: MyPageUseCases
    @Published private(set) var noticeList: [ExpandableNotice] = []
    var noticeListPublisher: Published<[ExpandableNotice]>.Publisher { $noticeList }
    
    init(actions: NoticeBoardViewModelActions, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultNoticeBoardViewModel {
    
    func getNoticeList() {
        Task {
            let result = await myPageUseCases.getNoticeList()
            switch result {
            case .success(let noticeList):
                print(noticeList)
                self.noticeList = noticeList.map { ExpandableNotice(notice: $0) }
            case .failure(let failure):
                print(failure.localizedDescription)
                self.noticeList = []
            }
        }
    }
    
    func didTapBackButton() {
        actions.pop()
    }
}
