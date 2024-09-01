//
//  NoticeBoardViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import Foundation

struct PlainWebViewLoadViewModelActions {
    let pop: () -> Void
}

protocol PlainWebViewLoadViewModelInput {
    func didTapBackButton()
}
protocol PlainWebViewLoadViewModelOutput {
    var webViewUrl: String { get }
}

typealias PlainWebViewLoadViewModel = PlainWebViewLoadViewModelInput & PlainWebViewLoadViewModelOutput

final class DefaultPlainWebViewLoadViewModel: PlainWebViewLoadViewModel {
    
    let webViewUrl: String
    
    private let actions: PlainWebViewLoadViewModelActions
    
    init(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) {
        self.actions = actions
        self.webViewUrl = webViewUrl
    }
}

extension DefaultPlainWebViewLoadViewModel {
    
    func didTapBackButton() {
        actions.pop()
    }
}
