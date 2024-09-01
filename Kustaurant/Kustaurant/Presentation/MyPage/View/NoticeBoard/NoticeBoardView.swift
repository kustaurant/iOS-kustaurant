//
//  NoticeBoardView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit
import WebKit

class NoticeBoardView: UIView {
    
    let webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoticeBoardView {
    
    private func setupUI() {
        addSubview(webView, autoLayout: [.fill(0)])
    }
}
