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
        noticeList = [
            ExpandableNotice(notice:
                Notice(noticeTitle: "쿠스토랑 첫번째 공지 - [1차 평가10개 이벤트당첨자 쿠폰수령안내]", noticeLink: "https://kustaurant.blogspot.com/2024/03/1-10.html", createdDate: "2024-03-27")
            ),
            ExpandableNotice(notice:
                Notice(noticeTitle: "쿠스토랑 두번째 공지 - [2차 맛집10곳 평가하고 스벅쿠폰받자! 이벤트]", noticeLink: "https://kustaurant.blogspot.com/2024/03/2-10.html", createdDate: "2024-03-31")
            ),
        ]
    }
    
    func didTapBackButton() {
        actions.pop()
    }
}
