//
//  NoticeContentTableViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/1/24.
//

import UIKit
import WebKit

class NoticeContentTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = String(describing: NoticeContentTableViewCell.self)
    
    private let webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoticeContentTableViewCell {
    
    private func setupUI() {
        contentView.addSubview(webView, autoLayout: [.fill(0)])
    }
    
    func loadWebView(with urlString: String?) {
        if
            let urlString = urlString,
            let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
